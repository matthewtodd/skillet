begin
  mount node[:cdrom][:mount_point]
rescue Chef::Exceptions::Exec
  Chef::Log.info("Could not mount #{node[:cdrom][:mount_point]}.")
else
  # TODO do something with apt to refresh its sense of what's on the cdrom
  # from the command line, this was: `apt-cdrom add` and then re-mounting the cdrom

  if File.directory?(node[:cdrom][:gems_directory])
    class Chef::Provider::Package::Rubygems < Chef::Provider::Package
      def candidate_version
        return @candidate_version if @candidate_version

        installed_versions = Dir.glob("#{node[:cdrom][:gems_directory]}/#{@new_resource.package_name}-[0-9]*.gem").map do |path|
          File.basename(path, '.gem').split('-').last
        end

        Chef::Log.debug("candidate_version: cdrom-bundled rubygem(s) available: #{installed_versions.inspect}")

        if installed_versions.empty?
          raise(Chef::Exceptions::Package, "Rubygem #{@new_resource.package_name} not found in #{node[:cdrom][:gems_directory]}!")
        else
          Chef::Log.debug("candidate_version: setting install candidate version to #{installed_versions.first}")
          @candidate_version = installed_versions.first
        end

        @candidate_version
      end

      def install_package(name, version)
        run_command(
          :command => "#{gem_binary_path} install #{name}-#{version}.gem --local --quiet --no-rdoc --no-ri",
          :cwd => node[:cdrom][:gems_directory]
        )
      end
    end
  end
end
