package 'dovecot-pop3d'

service 'dovecot' do
  action :enable
end

directory '/var/empty' do
  action :create
end

%w[dovecot.conf.bak dovecot-db-example.conf dovecot-ldap.conf].each do |path|
  file "/etc/dovecot/#{path}" do
    action :delete
    backup false
  end
end

template '/etc/dovecot/dovecot.conf' do
  source 'dovecot.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, resources(:service => 'dovecot')
end

%w[dovecot-sql.conf dovecot-sql-no-domain.conf].each do |path|
  template "/etc/dovecot/#{path}" do
    source "#{path}.erb"
    owner 'root'
    group 'root'
    mode 0600
    notifies :restart, resources(:service => 'dovecot')
  end
end
