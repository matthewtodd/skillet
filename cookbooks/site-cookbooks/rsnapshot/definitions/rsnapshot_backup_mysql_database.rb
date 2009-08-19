define :rsnapshot_backup_mysql_database do
  template "/etc/rsnapshot.d/#{params[:name]}_mysql_database" do
    backup false
    source 'backup_script.erb'
    cookbook 'rsnapshot'
    owner 'root'
    group 'root'
    mode 0644
    variables :command => "/usr/bin/mysqldump -u #{params[:username]} -p#{params[:password]} #{params[:name]} | gzip > #{params[:name]}.sql.gz", :directory => 'mysql_databases'
    notifies :create, resources(:template => '/etc/rsnapshot.conf')
  end
end
