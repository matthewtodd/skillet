def environment_variable(key)
  ENV[key.to_s.upcase] || raise("Please set ENV['#{key.to_s.upcase}'].")
end

Merb::Config.use do |config|
  config[:session_secret_key] = environment_variable(:session_secret_key)
end

Merb::BootLoader.before_app_loads do
  Chef::Config.instance_eval do
    authorized_openid_identifiers [environment_variable(:authorized_openid_identifier)]
    couchdb_url                   environment_variable(:couchdb_url)
    openid_url                    environment_variable(:openid_url)
  end
end
