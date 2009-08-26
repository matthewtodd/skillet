%w[merb-assets merb-helpers merb-slices].each do |merb_gem|
  gem merb_gem, '1.0.11'
  require merb_gem
end

require 'chef-server-slice'

gem 'matthewtodd-openid-store-couchdb-chef'
require 'openid-store-couchdb'

use_template_engine :haml

Merb::Config.use do |config|
  config[:session_store] = :cookie
end

Merb::BootLoader.before_app_loads do
  Chef::Config.instance_eval do
    cookbook_path         [Merb.root_path('cookbooks', 'site-cookbooks'), Merb.root_path('cookbooks', 'opscode-cookbooks')]
    openid_cstore_couchdb true
    openid_store_couchdb  true
    role_path             Merb.root_path('roles')
    search_index_path     Merb.root_path('tmp', 'search_index')
  end

  # MonkeyPatching Chef::Queue to no-op, since I don't have a queue
  # TODO call "straight through" to the Indexer instead.
  class Chef::Queue
    def self.connect
      $stderr.puts 'STUB - not really connecting to queue'
    end

    def self.send_msg(*args)
      $stderr.puts 'STUB - not really sending message to queue'
    end
  end
end
