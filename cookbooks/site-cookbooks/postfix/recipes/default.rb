package 'postfix'
package 'postfix-mysql'
package 'ca-certificates'

service 'postfix' do
  action :enable
end

Hectic.base_mailbox_paths(node).each do |mailbox_path|
  directory "#{node[:postfix][:virtual_mailbox_base]}/#{mailbox_path}" do
    owner 'nobody'
    group 'nogroup'
    mode 0775
    recursive true
    action :create
  end
end

template '/etc/postfix/main.cf' do
  source 'main.cf.erb'
  variables :virtual_mailbox_domains => Hectic.local_hostnames(node)
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, resources(:service => 'postfix')
end

template '/etc/postfix/master.cf' do
  source 'master.cf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, resources(:service => 'postfix')
end

# FIXME Chef::Resource::Template will only accept a Hash, not a Chef::Node::Attribute
database_configuration_hash = Hash.new
node[:hectic][:db].each_attribute { |k,v| database_configuration_hash[k]=v }

%w{relay_hosts smtp_passwords virtual_mailboxes}.each do |config|
  template "/etc/postfix/#{config}.cf" do
    source "#{config}.cf.erb"
    variables database_configuration_hash
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, resources(:service => 'postfix')
  end
end
