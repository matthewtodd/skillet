maintainer        'Matthew Todd'
maintainer_email  'matthew.todd@gmail.com'
license           'Apache 2.0'
description       'Installs and configures postfix for client or outbound relayhost, or to do SASL auth'
version           '0.1'

attribute "postfix/myhostname",
  :display_name => 'Postfix Myhostname',
  :description => 'Sets the myhostname value in main.cf',
  :default => 'fqdn'

attribute 'postfix/relayhost',
  :display_name => 'Postfix Relayhost',
  :description => 'Sets the relayhost value in main.cf',
  :default => ''

attribute 'postfix/smtp_sasl_user_name',
  :display_name => 'Postfix SMTP SASL Username',
  :description => 'User to auth SMTP via SASL',
  :default => ''

attribute 'postfix/smtp_sasl_passwd',
  :display_name => 'Postfix SMTP SASL Password',
  :description => 'Password for smtp_sasl_user_name',
  :default => ''
