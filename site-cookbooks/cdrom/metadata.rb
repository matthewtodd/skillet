maintainer        'Matthew Todd'
maintainer_email  'matthew.todd@gmail.com'
license           'Apache 2.0'
description       'Configures Chef to install gems from a local CD.'
version           '0.1'

attribute 'cdrom',
  :display_name => 'CDROM',
  :description => 'Hash of CDROM attributes',
  :type => 'hash'

attribute 'cdrom/device',
  :display_name => 'CDROM Device',
  :description => 'Full path on the system the CDROM device file.',
  :default => '/dev/scd0'

attribute 'cdrom/mount_point',
  :display_name => 'CDROM Mount Point',
  :description => 'Full path on the system where the CDROM will be mounted.',
  :default => '/media/cdrom0'

attribute 'cdrom/gems_directory',
  :display_name => 'CDROM Gems Directory',
  :description => 'Full path where the CDROM provides a pool of Rubygems.',
  :default => '/media/cdrom0/bundle/gems'
