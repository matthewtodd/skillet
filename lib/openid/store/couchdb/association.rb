module OpenID
  module Store
    class CouchDB < Interface

      class Association
        DESIGN_DOCUMENT = {
          'version' => 1,
          'language' => 'javascript',
          'views' => {}
        }

        class << self
          def create_design_document
            Chef::CouchDB.new.create_design_document('associations', DESIGN_DOCUMENT)
          end

          def create(server_url, association)
            new(document_name(server_url, association.handle), association).save
          end

          def load(server_url, handle)
            Chef::CouchDB.new.load('association', document_name(server_url, handle))
          rescue Net::HTTPServerException
            nil
          end

          def destroy(server_url, handle)
            document = load(server_url, handle)
            document ? document.destroy : false
          end

          def document_name(server_url, handle)
            Base64.encode64("#{server_url}-#{handle}").chomp
          end
        end

        attr_accessor :association

        def initialize(name, association, couchdb_rev = nil)
          @name        = name
          @association = association
          @couchdb_rev = couchdb_rev
          @couchdb     = Chef::CouchDB.new
        end

        def destroy
          @couchdb.delete('association', @name, @couchdb_rev)
        rescue Net::HTTPServerException
          false
        else
          true
        end

        def expired?
          @association.expires_in <= 0
        end

        def save
          results = @couchdb.store('association', @name, self)
          @couchdb_rev = results['rev']
        end

        def self.json_create(attributes)
          name        = attributes['name']
          handle      = attributes['handle']
          secret      = Base64.decode64(attributes['secret'])
          issued      = Time.at(attributes['issued'])
          lifetime    = attributes['lifetime']
          assoc_type  = attributes['assoc_type']
          couchdb_rev = attributes['_rev']
          association = OpenID::Association.new(handle, secret, issued, lifetime, assoc_type)

          new(name, association, couchdb_rev)
        end

        def to_json(*args)
          result = {
            'name' => @name,
            'json_class' => self.class.name,
            'chef_type' => 'association',
            'handle' => @association.handle,
            'secret' => Base64.encode64(@association.secret).chomp,
            'issued' => @association.issued.to_i,
            'lifetime' => @association.lifetime,
            'assoc_type' => @association.assoc_type,
          }
          result['_rev'] = @couchdb_rev if @couchdb_rev
          result.to_json(*args)
        end
      end

    end
  end
end
