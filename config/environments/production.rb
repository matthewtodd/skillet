def environment_variable(key)
  ENV[key.to_s.upcase] || raise("Please set ENV['#{key.to_s.upcase}'].")
end

Merb::Config.use do |config|
  config[:session_secret_key] = environment_variable(:session_secret_key)
end

Merb::BootLoader.before_app_loads do
  Chef::Config.instance_eval do
    couchdb_url environment_variable(:couchdb_url)
  end
end
