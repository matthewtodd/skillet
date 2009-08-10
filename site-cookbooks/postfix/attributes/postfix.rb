postfix Mash.new unless attribute?('postfix')

postfix[:myhostname]          = fqdn unless postfix.has_key?(:myhostname)
postfix[:relayhost]           = '' unless postfix.has_key?(:relayhost)
postfix[:smtp_sasl_user_name] = '' unless postfix.has_key?(:smtp_sasl_user_name)
postfix[:smtp_sasl_passwd]    = '' unless postfix.has_key?(:smtp_sasl_passwd)
