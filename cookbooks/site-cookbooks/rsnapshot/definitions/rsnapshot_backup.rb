define :rsnapshot_backup do
  template "/etc/rsnapshot.d/#{params[:name].gsub('/', '_')}" do
    backup false
    source 'backup.erb'
    cookbook 'rsnapshot'
    owner 'root'
    group 'root'
    mode 0644
    variables :directory => params[:name]
    notifies :create, resources(:template => '/etc/rsnapshot.conf')
  end
end
