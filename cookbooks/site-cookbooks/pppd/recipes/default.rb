package 'ppp'

template '/etc/ppp/options' do
  source 'options.erb'
  owner 'root'
  group 'root'
  mode 0644
end

node[:modems].each do |modem|
  template "/etc/ppp/options.#{modem[:device]}" do
    source 'options.device.erb'
    variables :remote_ip_address => modem[:remote_ip_address]
    owner 'root'
    group 'root'
    mode 0644
  end
end

template '/etc/ppp/pap-secrets' do
  source 'pap-secrets.erb'
  variables :accounts => Hectic.accounts(node)
  owner 'root'
  group 'root'
  mode 0600
end
