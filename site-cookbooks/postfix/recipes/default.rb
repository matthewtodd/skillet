package 'postfix'
package 'postfix-mysql'
package 'ca-certificates'

service 'postfix' do
  action :enable
end

Gem.clear_paths
require 'mysql'

virtual_mailbox_domains = []
mysql = Mysql.new('localhost', 'root', node[:mysql][:server_root_password], node[:hectic][:db][:database])
mysql.query('SELECT * FROM hosts ORDER BY name') do |result|
  result.each_hash do |hash|
    virtual_mailbox_domains.push(hash['name'])
  end
end
mysql.close

virtual_mailbox_domains.each do |domain|
  directory "/var/mail/virtual_mailboxes/#{domain}" do
    owner 5000
    group 5000
    mode 0775
    action :create
  end
end

%w{main master relay_hosts smtp_passwords virtual_mailboxes}.each do |config|
  template "/etc/postfix/#{config}.cf" do
    source "#{config}.cf.erb"
    variables :virtual_mailbox_domains => virtual_mailbox_domains
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, resources(:service => 'postfix')
  end
end
