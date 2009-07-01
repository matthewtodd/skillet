# Rackup file for deployment to Heroku or somewhere like it.
#
# For local development, you'll be better off using "merb" rather than
# "rackup", as rackup doesn't support running the cluster of 2 app servers
# necessary for chef's openid functionality.
#
# (See config/environments/development.rb.)
#
require 'rubygems'
require 'merb-core'

Merb::Config.setup(:environment => ENV['RACK_ENV'])
Merb::BootLoader.run
eval File.read(Merb.dir_for(:config) / 'rack.rb')
