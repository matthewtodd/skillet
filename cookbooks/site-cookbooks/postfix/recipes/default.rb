package 'postfix'
package 'postfix-mysql'
package 'ca-certificates'

service 'postfix' do
  action :enable
end

Hectic.base_mailbox_paths(node).each do |mailbox_path|
  directory "#{node[:postfix][:virtual_mailbox_base]}/#{mailbox_path}" do
    owner 5000
    group 5000
    mode 0775
    action :create
  end
end

template "/etc/postfix/main.cf" do
  source "main.cf.erb"
  variables :virtual_mailbox_domains => Hectic.local_hostnames(node)
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, resources(:service => 'postfix')
end

%w{master relay_hosts smtp_passwords virtual_mailboxes}.each do |config|
  template "/etc/postfix/#{config}.cf" do
    source "#{config}.cf.erb"
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, resources(:service => 'postfix')
  end
end
