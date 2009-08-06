r = gem_package 'chef-deploy' do
  source 'http://gems.engineyard.com'
  version node[:chef_deploy][:version]
  action :nothing
end

r.run_action(:install)

begin
  gem 'chef-deploy'
rescue Gem::LoadError
  Gem.refresh
  gem 'chef-deploy'
ensure
  require 'chef-deploy'
end
