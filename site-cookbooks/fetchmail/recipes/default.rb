package 'fetchmail'

service 'fetchmail' do
  action :enable
end

template '/etc/default/fetchmail' do
  source 'fetchmail.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, resources(:service => 'fetchmail')
end

Gem.clear_paths
require 'mysql'

accounts = []
mysql = Mysql.new('localhost', 'root', node[:mysql][:server_root_password], node[:hectic][:db][:database])
mysql.query('SELECT * FROM hosts JOIN accounts ON hosts.id=accounts.host_id ORDER BY hosts.name, accounts.username') do |result|
  result.each_hash { |hash| accounts << hash }
end
mysql.close

template '/etc/fetchmailrc' do
  source 'fetchmailrc.erb'
  variables :accounts => accounts
  owner 'fetchmail'
  group 'nogroup'
  mode 0600
  notifies :restart, resources(:service => 'fetchmail')
end
