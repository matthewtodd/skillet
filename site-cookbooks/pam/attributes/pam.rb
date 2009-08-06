pam Mash.new unless attribute?('pam')
pam[:environment] = Mash.new unless pam.has_key?(:environment)
pam[:environment][:paths] = [
  "#{languages[:ruby][:gems_dir]}/bin",
  '/usr/local/sbin',
  '/usr/local/bin',
  '/usr/sbin',
  '/usr/bin',
  '/sbin',
  '/bin'
] unless pam[:environment].has_key?(:paths)