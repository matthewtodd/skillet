require 'ipaddr'

set_unless.modems = [{
  :device => 'ttyS0',
  :speed => 57600,
  :remote_ip_address => IPAddr.new(ipaddress).succ
}]
