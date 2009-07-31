maintainer        'Matthew Todd'
maintainer_email  'matthew.todd@gmail.com'
license           'Apache 2.0'
description       'Installs and configures fetchmail'
version           '0.1'
supports          'ubuntu' # MAY work with others; I don't know.

attribute 'fetchmail/limit',
  :display_name => 'Fetchmail Limit',
  :description => '', # FIXME learn what fetchmail/limit means
  :default => nil

attribute 'fetchmail/fetchlimit',
  :display_name => 'Fetchmail Fetchlimit',
  :description => '', # FIXME learn what fetchmail/fetchlimit means
  :default => nil

attribute 'fetchlimit/timeout',
  :display_name => 'Fetchmail Timeout',
  :description => '', # FIXME learn what fetchmail/timeout means
  :default => nil
