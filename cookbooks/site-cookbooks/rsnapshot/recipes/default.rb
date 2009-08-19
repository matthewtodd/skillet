require 'pathname'

package 'rsnapshot'

directory '/etc/rsnapshot.d' do
  owner 'root'
  group 'root'
  mode 0755
end

template '/etc/rsnapshot.conf' do
  source 'rsnapshot.conf.erb'
  variables :fragments_directory => Pathname.new('/etc/rsnapshot.d')
  owner 'root'
  group 'root'
  mode 0644
end

template '/etc/cron.d/rsnapshot' do
  backup false
  source 'rsnapshot.erb'
  owner 'root'
  group 'root'
  mode 0644
end

rsnapshot_backup '/var/log'
