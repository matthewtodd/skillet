chef_deploy Mash.new unless attribute?('chef_deploy')
chef_deploy[:version] = '0.2.3'
