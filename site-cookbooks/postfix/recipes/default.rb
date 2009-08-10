%w{postfix libsasl2-2 ca-certificates}.each do |pkg|
  package pkg do
    action :install
  end
end

service "postfix" do
  action :enable
end

%w{main master}.each do |cfg|
  template "/etc/postfix/#{cfg}.cf" do
    source "#{cfg}.cf.erb"
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, resources(:service => 'postfix')
  end
end

execute 'postmap-sasl_passwd' do
  command 'postmap /etc/postfix/sasl_passwd'
  action :nothing
end

template '/etc/postfix/sasl_passwd' do
  source 'sasl_passwd.erb'
  owner 'root'
  group 'root'
  mode 0400
  notifies :run, resources(:execute => 'postmap-sasl_passwd')
  notifies :restart, resources(:service => 'postfix')
end
