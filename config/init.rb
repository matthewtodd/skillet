MERB_GEMS_VERSION = '> 1.0'

dependency 'merb-core',    MERB_GEMS_VERSION
dependency 'merb-assets',  MERB_GEMS_VERSION
dependency 'merb-helpers', MERB_GEMS_VERSION
dependency 'merb-slices',  MERB_GEMS_VERSION
dependency 'chef-server-slice'

use_template_engine :haml

Merb::Config.use do |config|
  config[:session_id_key]     = '_chef_server_session_id'
  config[:session_secret_key] = 'asdfasdfasdfasdf'
  config[:session_store]      = 'cookie'
end

Merb::BootLoader.before_app_loads do
  Chef::Config.instance_eval do
    openid_cstore_path Merb.root_path('tmp')
    openid_store_path  Merb.root_path('tmp')
    search_index_path  Merb.root_path('tmp', 'search_index')    
  end

  class Chef::Queue
    def self.connect
      $stderr.puts 'STUB - not really connecting to queue'
    end
    
    def self.send_msg(*args)
      $stderr.puts 'STUB - not really sending message to queue'      
    end
  end
end
