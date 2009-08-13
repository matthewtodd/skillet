define :capistrano_deployment_structure, :action => :create do
  cap_directories = [
    "#{params[:name]}",
    "#{params[:name]}/releases",
    "#{params[:name]}/shared",
    "#{params[:name]}/shared/config",
    "#{params[:name]}/shared/log",
    "#{params[:name]}/shared/pids"
  ]

  cap_directories.each do |path|
    directory path do
      recursive true
      owner params[:owner]
      group params[:group]
      mode 0755
    end
  end

  template "#{params[:name]}/shared/config/database.yml" do
    source 'database.yml.erb'
    owner params[:owner]
    group params[:group]
    mode 0600
    variables params[:database_configuration]
  end
end