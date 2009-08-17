maintainer        'Matthew Todd'
maintainer_email  'matthew.todd@gmail.com'
license           'Apache 2.0'
description       'Configures Chef to install gems from a local directory.'
version           '0.1'

attribute 'local_rubygems/directory',
  :display_name => 'Local Rubygems Directory',
  :description => 'Directory holding gem packages to be installed.',
  :default => '/root/gems'
