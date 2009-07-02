module OpenID
  module Store
    class CouchDB < Interface

      class Nonce
        DESIGN_DOCUMENT = {
          'version' => 1,
          'language' => 'javascript',
          'views' => {}
        }

        class << self
          def create_design_document
            Chef::CouchDB.new.create_design_document('nonces', DESIGN_DOCUMENT)
          end

          def create(server_url, timestamp, salt)
            new(server_url, timestamp, salt).save
          end
        end

        def initialize(server_url, timestamp, salt, couchdb_rev = nil)
          @server_url  = server_url
          @timestamp   = Time.at(timestamp.to_i)
          @salt        = salt
          @couchdb_rev = nil
          @couchdb     = Chef::CouchDB.new
        end

        def name
          [@timestamp.strftime(OpenID::Nonce::TIME_FMT), Base64.encode64(@server_url).chomp, Base64.encode64(@salt).chomp].join('-')
        end

        def save
          return false unless valid?

          begin
            results = @couchdb.store('nonce', name, self)
          rescue Net::HTTPServerException
            false
          else
            @couchdb_rev = results['rev']
            true
          end
        end

        def valid?
          OpenID::Nonce.check_timestamp(name)
        end

        def self.json_create(attributes)
          server_url  = attributes['server_url']
          timestamp   = Time.at(attributes['timestamp'])
          salt        = attributes['salt']
          couchdb_rev = attributes['_rev']

          new(server_url, timestamp, salt, couchdb_rev)
        end

        def to_json(*args)
          result = {
            'json_class' => self.class.name,
            'chef_type' => 'nonce',
            'server_url' => @server_url,
            'timestamp' => @timestamp.to_i,
            'salt' => @salt,
          }
          result['_rev'] = @couchdb_rev if @couchdb_rev
          result.to_json(*args)
        end
      end

    end
  end
end
