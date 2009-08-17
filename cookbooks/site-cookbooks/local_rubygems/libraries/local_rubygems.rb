class Chef::Provider::Package::Rubygems < Chef::Provider::Package
  def candidate_version
    return @candidate_version if @candidate_version

    installed_versions = ::Dir.glob("#{node[:local_rubygems][:directory]}/#{@new_resource.package_name}-[0-9]*.gem").map do |path|
      ::File.basename(path, '.gem').split('-').last
    end

    Chef::Log.debug("candidate_version: cdrom-bundled rubygem(s) available: #{installed_versions.inspect}")

    if installed_versions.empty?
      raise(Chef::Exceptions::Package, "Rubygem #{@new_resource.package_name} not found in #{node[:local_rubygems][:directory]}!")
    else
      Chef::Log.debug("candidate_version: setting install candidate version to #{installed_versions.first}")
      @candidate_version = installed_versions.first
    end

    @candidate_version
  end

  def install_package(name, version)
    Chef::Log.debug("Installing #{name}-#{version}.gem from #{node[:local_rubygems][:directory]}")
    run_command(
      :command => "#{gem_binary_path} install #{name}-#{version}.gem --local --quiet --no-rdoc --no-ri",
      :cwd => node[:local_rubygems][:directory]
    )
  end
end
