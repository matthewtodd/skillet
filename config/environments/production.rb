Merb::Config.use do |config|
  config[:session_secret_key] = ENV['MERB_SESSION_SECRET_KEY']
end

Merb::BootLoader.before_app_loads do
  Chef::Config.instance_eval do
    authorized_openid_identifiers ENV['CHEF_AUTHORIZED_OPENID_IDENTIFIERS'].split(',')
    couchdb_url                   ENV['CHEF_COUCHDB_URL']
    openid_url                    ENV['CHEF_OPENID_URL']
  end
end
