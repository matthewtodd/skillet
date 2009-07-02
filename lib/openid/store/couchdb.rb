require 'openid'
require 'openid/store/interface'
require 'openid/store/couchdb/association'
require 'openid/store/couchdb/nonce'

module OpenID
  module Store

    class CouchDB < Interface
      def initialize(*args)
        Association.create_design_document
        Nonce.create_design_document
      end

      # Put a Association object into storage.
      # When implementing a store, don't assume that there are any limitations
      # on the character set of the server_url.  In particular, expect to see
      # unescaped non-url-safe characters in the server_url field.
      def store_association(server_url, association)
        if document = Association.load(server_url, association.handle)
          document.association = association
          document.save
        else
          Association.create(server_url, association)
        end
      end

      # Returns a Association object from storage that matches
      # the server_url.  Returns nil if no such association is found or if
      # the one matching association is expired. (Is allowed to GC expired
      # associations when found.)
      def get_association(server_url, handle=nil)
        if document = Association.load(server_url, handle)
          if document.expired?
            document.destroy
            nil
          else
            document.association
          end
        end
      end

      # If there is a matching association, remove it from the store and
      # return true, otherwise return false.
      def remove_association(server_url, handle)
        Association.destroy(server_url, handle)
      end

      # Remove expired associations from the store
      # Not called during normal library operation, this method is for store
      # admins to keep their storage from filling up with expired data
      def cleanup_associations
        raise NotImplementedError
      end

      # Return true if the nonce has not been used before, and store it
      # for a while to make sure someone doesn't try to use the same value
      # again.  Return false if the nonce has already been used or if the
      # timestamp is not current.
      # You can use OpenID::Store::Nonce::SKEW for your timestamp window.
      # server_url: URL of the server from which the nonce originated
      # timestamp: time the nonce was created in seconds since unix epoch
      # salt: A random string that makes two nonces issued by a server in
      #       the same second unique
      def use_nonce(server_url, timestamp, salt)
        Nonce.create(server_url, timestamp, salt)
      end

      # Remove expired nonces from the store
      # Discards any nonce that is old enough that it wouldn't pass use_nonce
      # Not called during normal library operation, this method is for store
      # admins to keep their storage from filling up with expired data
      def cleanup_nonces
        raise NotImplementedError
      end
    end

  end
end
