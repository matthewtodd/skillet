class RequireSSL < Struct.new(:app)
  def call(env)
    if env['HTTPS'] == 'on' || env['HTTP_X_FORWARDED_PROTO'] == 'https'
      app.call(env)
    else
      # I'd rather not redirect; we'll be receiving non-GET requests as well.
      [ 400, {}, 'SSL is required.' ]
    end
  end
end

use RequireSSL unless Merb.environment == 'development'
use Merb::Rack::Static, ChefServerSlice.dir_for(:public)
run Merb::Rack::Application.new
