mount node[:cdrom][:mount_point] do
  device node[:cdrom][:device]
end
