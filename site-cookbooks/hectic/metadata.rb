maintainer        'Matthew Todd'
maintainer_email  'matthew.todd@gmail.com'
license           'Apache 2.0'
description       'Installs and configures the "hectic" Rails app.'
version           '0.1'
depends           'apache2'
depends           'passenger_apache2::mod_rails'
depends           'mysql::server'
depends           'rails'
depends           'chef_deploy'

attribute 'hectic',
  :display_name => 'Hectic',
  :description => 'Hash of hectic attributes',
  :type => 'hash'

attribute 'hectic/server_name',
  :display_name => 'Hectic server name',
  :description => 'Virtual hostname serving the hectic application.',
  :default => 'node[:fqdn]'

attribute 'hectic/revision',
  :display_name => 'Hectic revision',
  :description => 'Git SHA of the hectic revision to be deployed.',
  :default => ''
