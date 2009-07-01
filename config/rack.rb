class RequireSSL
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['rack.url_scheme'] == 'https'
      @app.call(env)
    else
      [ 400, {}, 'SSL is required.' ]
    end
  end
end

unless Merb.environment == 'development'
  use RequireSSL
  use Rack::Auth::Basic do |api_key, _|
    api_key == ENV['API_KEY']
  end
end

use Merb::Rack::Static, ChefServerSlice.dir_for(:public)
run Merb::Rack::Application.new
