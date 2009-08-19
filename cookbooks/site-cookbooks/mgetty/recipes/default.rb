package 'mgetty'

template '/etc/mgetty/mgetty.config' do
  source 'mgetty.config.erb'
  variables :modems => node[:modems]
  owner 'root'
  group 'root'
  mode 0644
end

template '/etc/mgetty/login.config' do
  source 'login.config.erb'
  owner 'root'
  group 'root'
  mode 0600
end

template '/etc/mgetty/dialin.config' do
  source 'dialin.config.erb'
  owner 'root'
  group 'root'
  mode 0644
end

node[:modems].each do |modem|
  device = modem[:device]

  execute "start-mgetty-#{device}" do
    command "/sbin/start #{device}"
    action :nothing
  end

  template "/etc/event.d/#{device}" do
    backup false
    source 'device.erb'
    variables :device => device
    owner 'root'
    group 'root'
    mode 0644
    notifies :run, resources(:execute => "start-mgetty-#{device}")
  end
end
