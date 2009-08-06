require 'chef-deploy'

execute "create #{node[:hectic][:db][:database]} database" do
  command "/usr/bin/mysqladmin -u root -p#{node[:mysql][:server_root_password]} create #{node[:hectic][:db][:database]}"
  not_if  "/usr/bin/mysqlshow  -u root -p#{node[:mysql][:server_root_password]} | grep #{node[:hectic][:db][:database]}"
end

[node[:hectic][:deploy_to], "#{node[:hectic][:deploy_to]}/releases", "#{node[:hectic][:deploy_to]}/shared/config"].each do |path|
  directory path do
    recursive true
    owner node[:apache][:user]
    group node[:apache][:user]
    mode 0755
  end
end

template "#{node[:hectic][:deploy_to]}/shared/config/database.yml" do
  source 'database.yml.erb'
  owner node[:apache][:user]
  group node[:apache][:user]
  mode 0600
  # it seems like attribute files shouldn't reference attributes outside
  # themselves; but mysql[:server_root_password] will be defined by now
  variables node[:hectic][:db].merge(:username => 'root', :password => mysql[:server_root_password])
end

deploy node[:hectic][:deploy_to] do
  repo 'git://github.com/matthewtodd/hectic.git'
  migrate true
  migration_command "#{node[:languages][:ruby][:gems_dir]}/bin/rake db:migrate"
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
  cookbook 'passenger_apache2'
end

# TODO schedule database backups?