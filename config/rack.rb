class RequireSSL
  def initialize(app)
    @app = app
  end

  def call(env)
    ssl?(env) ? @app.call(env) : bad_request
  end

  private

  def ssl?(env)
    env['HTTPS'] == 'on' || env['HTTP_X_FORWARDED_PROTO'] == 'https'
  end

  def bad_request
    [ 400, {}, 'SSL is required.' ]
  end
end

class RequireBasicAuthentication < Rack::Auth::Basic
  def realm
    'The Kitchen'
  end
end

unless Merb.environment == 'development'
  use RequireSSL
  use RequireBasicAuthentication do |access_token, _|
    access_token == ENV['APP_ACCESS_TOKEN']
  end
end

use Merb::Rack::Static, ChefServerSlice.dir_for(:public)
run Merb::Rack::Application.new
