# Rackup file for deployment to Heroku or somewhere like it.
#
# For local development, you'll be better off using "merb" rather than
# "rackup", as rackup doesn't support running the cluster of 2 app servers
# necessary for chef's openid functionality.
#
# (See config/environments/development.rb.)
#
require 'rubygems'
gem 'merb-core', '1.0.11'
require 'merb-core'

Merb::Config.setup(:environment => ENV['RACK_ENV'])
Merb::BootLoader.run
run Merb::Config[:app]
