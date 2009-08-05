require 'chef-deploy'

execute "create #{node[:hectic][:db][:database]} database" do
  command "/usr/bin/mysqladmin -u root -p#{node[:mysql][:server_root_password]} create #{node[:hectic][:db][:database]}"
  not_if  "/usr/bin/mysqlshow | grep #{node[:hectic][:db][:database]}"
end

template "#{node[:hectic][:deploy_to]}/shared/config/database.yml" do
  source 'database.yml.erb'
  user node[:apache][:user]
  group node[:apache][:user]
  mode '0600'
  variables node[:hectic][:db]
end

deploy node[:hectic][:deploy_to] do
  repo 'git://github.com/matthewtodd/hectic.git'
  migrate true
  migration_command 'rake db:migrate'
  environment node[:hectic][:environment]
  restart_command 'touch tmp/restart.txt'
  user node[:apache][:user]
  group node[:apache][:user]
end

web_app 'hectic' do
  docroot "#{node[:hectic][:deploy_to]}/current/public"
  server_name node[:hectic][:server_name]
  server_aliases node[:hectic][:server_aliases]
  rails_env node[:hectic][:environment]
  template 'passenger_web_app.conf.erb'
end

# TODO schedule database backups?