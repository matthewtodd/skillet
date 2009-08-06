template '/etc/environment' do
  source 'environment.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables node[:pam][:environment]
end
