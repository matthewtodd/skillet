require 'chef-deploy'
require 'pathname'

mysql_database node[:hectic][:db][:database] do
  username node[:hectic][:db][:username]
  password node[:hectic][:db][:password]
end

rsnapshot_backup_mysql_database node[:hectic][:db][:database] do
  username node[:hectic][:db][:username]
  password node[:hectic][:db][:password]
end

# FIXME Chef::Resource::Template will only accept a Hash, not a Chef::Node::Attribute
database_configuration_hash = Hash.new
node[:hectic][:db].each_attribute { |k,v| database_configuration_hash[k]=v }

capistrano_deployment_structure node[:hectic][:deploy_to] do
  owner node[:apache][:user]
  group node[:apache][:user]
  database_configuration database_configuration_hash
end

# Include gem dependencies here because of a bug in chef-deploy: the code that
# reads gems.yml references Chef::Exception, but it should be
# Chef::Exceptions, with an s on the end. And I kind of felt a little weird
# about the yaml file anyway.
gem_package 'haml'

deploy node[:hectic][:deploy_to] do
  repo 'git://github.com/matthewtodd/hectic.git'
  revision node[:hectic][:revision]
  migrate true
  migration_command 'rake db:migrate'
  environment node[:hectic][:environment]
  restart_command 'touch tmp/restart.txt'
  user node[:apache][:user]
  group node[:apache][:user]

  current_revision = Pathname.new(node[:hectic][:deploy_to]).join('current', 'REVISION')
  if current_revision.exist? && current_revision.read.strip == node[:hectic][:revision]
    action :nothing
  else
    action :deploy
  end
end

template node[:hectic][:server_password_file] do
  source 'htpasswd.erb'
  variables :username => node[:hectic][:server_username], :password => node[:hectic][:server_password]
end

web_app 'hectic' do
  docroot "#{node[:hectic][:deploy_to]}/current/public"
  server_name node[:hectic][:server_name]
  server_aliases node[:hectic][:server_aliases]
  server_username node[:hectic][:server_username]
  server_password_file node[:hectic][:server_password_file]
  rails_env node[:hectic][:environment]
  template 'hectic_web_app.conf.erb'
end

apache_site '000-default' do
  enable false
end

template '/etc/logrotate.d/hectic' do
  source 'logrotate-hectic.erb'
  variables :base => node[:hectic][:deploy_to]
  owner 'root'
  group 'root'
  mode 0644
end
