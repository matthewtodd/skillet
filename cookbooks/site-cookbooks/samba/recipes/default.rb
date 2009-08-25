package 'samba'

service 'samba' do
  action :enable
end

template '/etc/samba/smb.conf' do
  source 'smb.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, resources(:service => 'samba')
end

user node[:samba][:user] do
  home node[:samba][:path]
  shell '/bin/false'
end

directory node[:samba][:path] do
  owner node[:samba][:user]
  group node[:samba][:group]
  recursive true
end

execute "/usr/bin/smbpasswd -a -n #{node[:samba][:user]}" do
  not_if "/bin/grep #{node[:samba][:user]} /etc/samba/smbpasswd"
end

# always set the password, so we can change it with attributes.
execute "set smbpasswd for #{node[:samba][:user]}" do
  command "/bin/echo -e '#{node[:samba][:password]}\n#{node[:samba][:password]}' | /usr/bin/smbpasswd -s #{node[:samba][:user]}"
end

rsnapshot_backup node[:samba][:path]
