package 'fetchmail'

service 'fetchmail' do
  action :enable
end

template '/etc/default/fetchmail' do
  source 'fetchmail.erb'
  mode 0644
  owner 'root'
  group 'root'
end
