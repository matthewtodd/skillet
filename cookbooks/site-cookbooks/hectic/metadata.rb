maintainer        'Matthew Todd'
maintainer_email  'matthew.todd@gmail.com'
license           'Apache 2.0'
description       'Installs and configures the "hectic" Rails app.'
version           '0.1'

attribute 'hectic',
  :display_name => 'Hectic',
  :description => 'Hash of hectic attributes',
  :type => 'hash'

attribute 'hectic/server_name',
  :display_name => 'Hectic server name',
  :description => 'Virtual hostname serving the hectic application.',
  :default => 'fqdn'

attribute 'hectic/revision',
  :display_name => 'Hectic revision',
  :description => 'Git SHA of the hectic revision to be deployed.',
  :default => ''
