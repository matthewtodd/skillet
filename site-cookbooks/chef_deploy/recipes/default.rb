gem_package 'chef-deploy' do
  source 'http://gems.engineyard.com'
  version node[:chef_deploy][:version]
end
