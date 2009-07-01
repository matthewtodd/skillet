Merb::Config.use do |config|
  config[:cluster]            = 2
  config[:daemonize]          = true
  config[:exception_details]  = true
  config[:session_secret_key] = 'asdfasdfasdfasdf'
end

Merb::BootLoader.before_app_loads do
  Chef::Config.instance_eval do
    couchdb_url 'http://development_hideabed_api_key:X@localhost:3000'
  end
end

Merb::BootLoader.after_app_loads do
  unless Chef::OpenIDRegistration.has_key?('admin')
    admin_account = Chef::OpenIDRegistration.new
    admin_account.name = 'admin'
    admin_account.set_password 'password'
    admin_account.validated = true
    admin_account.admin = true
    admin_account.save
  end
end
