maintainer        'Matthew Todd'
maintainer_email  'matthew.todd@gmail.com'
license           'Apache 2.0'
description       'Installs the chef-deploy gem'
version           '0.1'
depends           'git'
depends           'ruby'

attribute 'chef_deploy',
  :display_name => 'Chef Deploy',
  :description => 'Hash of Chef Deploy attributes',
  :type => 'hash'

attribute 'chef_deploy/version',
  :display_name => 'Chef Deploy Version',
  :description => 'Version of the chef-deploy gem to install.',
  :default => '0.2.3'
