mount node[:cdrom][:mount_point] do
  device node[:cdrom][:device]
  fstype 'udf,iso9660'
end
