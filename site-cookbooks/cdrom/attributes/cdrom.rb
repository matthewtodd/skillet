cdrom Mash.new unless attribute?('cdrom')
cdrom[:device]         = '/dev/scd0' unless cdrom.has_key?(:device)
cdrom[:mount_point]    = '/media/cdrom0' unless cdrom.has_key?(:mount_point)
cdrom[:gems_directory] = "#{cdrom[:mount_point]}/bundle/gems" unless cdrom.has_key?(:gems_directory)
