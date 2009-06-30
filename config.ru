require 'rubygems'
require 'merb-core'

Merb::Config.setup(:environment => ENV['RACK_ENV'])
Merb::BootLoader.run
eval File.read(Merb.dir_for(:config) / 'rack.rb')
