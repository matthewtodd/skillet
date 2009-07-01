class RequireSSL
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['rack.url_scheme'] == 'https'
      @app.call(env)
    else
      [ 400, {}, "SSL is required.\n#{env.inspect}" ]
    end
  end
end

unless Merb.environment == 'development'
  use RequireSSL
  use Rack::Auth::Basic do |access_token, _|
    api_key == ENV['APP_ACCESS_TOKEN']
  end
end

use Merb::Rack::Static, ChefServerSlice.dir_for(:public)
run Merb::Rack::Application.new
