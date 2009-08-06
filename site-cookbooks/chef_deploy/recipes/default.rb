include_recipe 'git'
include_recipe 'ruby'

gem_package 'chef-deploy' do
  source 'http://gems.engineyard.com'
  version node[:chef_deploy][:version]
end

begin
  gem 'chef-deploy'
rescue Gem::LoadError
  Gem.refresh
ensure
  require 'chef-deploy'
end
