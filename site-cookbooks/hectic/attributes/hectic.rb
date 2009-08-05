hectic Mash.new unless attribute?('hectic')

hectic[:deploy_to]      = '/var/www/apps/hectic'
hectic[:server_name]    = fqdn unless hectic.has_key?(:server_name)
hectic[:server_aliases] = []
hectic[:environment]    = 'production'
hectic[:revision]       = '' unless hectic.has_key?(:revision)

hectic[:db] = Mash.new
hectic[:db][:environment] = hectic[:environment]
hectic[:db][:database]    = 'hectic'
hectic[:db][:username]    = 'root'
hectic[:db][:password]    = mysql[:server_root_password]
hectic[:db][:socket]      = '/var/run/mysqld/mysqld.sock'
