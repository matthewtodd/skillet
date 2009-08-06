maintainer        'Matthew Todd'
maintainer_email  'matthew.todd@gmail.com'
license           'Apache 2.0'
description       'Configures PAM modules.'
version           '0.1'

attribute 'pam',
  :display_name => 'PAM',
  :description => 'Hash of pam attributes',
  :type => 'hash'

attribute 'pam/environment',
  :display_name => 'PAM environment variables.',
  :description => 'Just like it says.',
  :type => 'hash'

attribute 'pam/environment/paths',
  :display_name => 'PAM environment paths.',
  :description => 'Components of the PATH environment variable.',
  :default => [
    'gems_dir/bin',
    '/usr/local/sbin',
    '/usr/local/bin',
    '/usr/sbin',
    '/usr/bin',
    '/sbin',
    '/bin'],
  :type => 'array'
