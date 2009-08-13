define :mysql_database, :action => :create do
  execute "create #{params[:name]} database" do
    command "/usr/bin/mysqladmin -u root -p#{node[:mysql][:server_root_password]} create #{params[:name]}"
    not_if  "/usr/bin/mysqlshow  -u root -p#{node[:mysql][:server_root_password]} #{params[:name]}"
  end

  execute "grant #{params[:username]} user access to #{params[:name]} database" do
    command %{/bin/echo "GRANT ALL ON #{params[:name]}.* TO '#{params[:username]}'@'localhost' IDENTIFIED BY '#{params[:password]}'" | /usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -s}
    only_if %{/bin/echo "SELECT COUNT(*) FROM db WHERE Host='localhost' AND Db='#{params[:name]}' AND User='#{params[:username]}';" | /usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -s mysql | /usr/bin/xargs /usr/bin/test -0 -eq}
  end
end