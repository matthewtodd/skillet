MERB_GEMS_VERSION = '> 1.0'

dependency 'merb-core',    MERB_GEMS_VERSION
dependency 'merb-assets',  MERB_GEMS_VERSION
dependency 'merb-helpers', MERB_GEMS_VERSION
dependency 'merb-slices',  MERB_GEMS_VERSION
dependency 'chef-server-slice'

use_template_engine :haml

Merb::Config.use do |config|
  config[:session_store] = :cookie
end

Merb::BootLoader.before_app_loads do
  Chef::Config.instance_eval do
    openid_cstore_path Merb.root_path('tmp')
    openid_store_path  Merb.root_path('tmp')
    search_index_path  Merb.root_path('tmp', 'search_index')
  end

  # MonkeyPatching Chef::Queue to no-op, since I don't have a queue
  class Chef::Queue
    def self.connect
      $stderr.puts 'STUB - not really connecting to queue'
    end

    def self.send_msg(*args)
      $stderr.puts 'STUB - not really sending message to queue'
    end
  end

  # MonkeyPatching Chef:REST to provide support for basic authentication
  class Chef::REST
    def run_request(method, url, data=false, limit=10, raw=false)
      http_retry_delay = Chef::Config[:http_retry_delay]
      http_retry_count = Chef::Config[:http_retry_count]

      raise ArgumentError, 'HTTP redirect too deep' if limit == 0

      http = Net::HTTP.new(url.host, url.port)
      if url.scheme == "https"
        http.use_ssl = true
        if Chef::Config[:ssl_verify_mode] == :verify_none
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        if File.exists?(Chef::Config[:ssl_client_cert])
          http.cert = OpenSSL::X509::Certificate.new(File.read(Chef::Config[:ssl_client_cert]))
          http.key = OpenSSL::PKey::RSA.new(File.read(Chef::Config[:ssl_client_key]))
        end
      end
      http.read_timeout = Chef::Config[:rest_timeout]
      headers = Hash.new
      unless raw
        headers = {
          'Accept' => "application/json",
        }
      end
      if @cookies.has_key?("#{url.host}:#{url.port}")
        headers['Cookie'] = @cookies["#{url.host}:#{url.port}"]
      end
      req = nil
      case method
      when :GET
        req_path = "#{url.path}"
        req_path << "?#{url.query}" if url.query
        req = Net::HTTP::Get.new(req_path, headers)
      when :POST
        headers["Content-Type"] = 'application/json' if data
        req = Net::HTTP::Post.new(url.path, headers)
        req.body = data.to_json if data
      when :PUT
        headers["Content-Type"] = 'application/json' if data
        req = Net::HTTP::Put.new(url.path, headers)
        req.body = data.to_json if data
      when :DELETE
        req_path = "#{url.path}"
        req_path << "?#{url.query}" if url.query
        req = Net::HTTP::Delete.new(req_path, headers)
      else
        raise ArgumentError, "You must provide :GET, :PUT, :POST or :DELETE as the method"
      end

      # perform basic authentication as needed
      req.basic_auth(url.user, url.password) if url.user

      Chef::Log.debug("Sending HTTP Request via #{req.method} to #{req.path}")
      res = nil
      tf = nil
      http_retries = 1

      # TODO - Figure out how to test this block - I really have no idea how
      # to do it without actually calling http.request...
      begin
        res = http.request(req) do |response|
          if raw
            tf = Tempfile.new("chef-rest")
            # Stolen from http://www.ruby-forum.com/topic/166423
            # Kudos to _why!
            size, total = 0, response.header['Content-Length'].to_i
            response.read_body do |chunk|
              tf.write(chunk)
              size += chunk.size
              if size == 0
                Chef::Log.debug("#{req.path} done (0 length file)")
              elsif total == 0
                Chef::Log.debug("#{req.path} (zero content length)")
              else
                Chef::Log.debug("#{req.path} %d%% done (%d of %d)" % [(size * 100) / total, size, total])
              end
            end
            tf.close
            tf
          else
            response.read_body
          end
          response
        end
      rescue Errno::ECONNREFUSED
        Chef::Log.error("Connection refused connecting to #{url.host}:#{url.port} for #{req.path} #{http_retries}/#{http_retry_count}")
        sleep(http_retry_delay)
        retry if (http_retries += 1) < http_retry_count
        raise Errno::ECONNREFUSED, "Connection refused connecting to #{url.host}:#{url.port} for #{req.path}, giving up"
      rescue Timeout::Error
        Chef::Log.error("Timeout connecting to #{url.host}:#{url.port} for #{req.path}, retry #{http_retries}/#{http_retry_count}")
        sleep(http_retry_delay)
        retry if (http_retries += 1) < http_retry_count
        raise Timeout::Error, "Timeout connecting to #{url.host}:#{url.port} for #{req.path}, giving up"
      end

      if res.kind_of?(Net::HTTPSuccess)
        if res['set-cookie']
          @cookies["#{url.host}:#{url.port}"] = res['set-cookie']
        end
        if res['content-type'] =~ /json/
          JSON.parse(res.body)
        else
          if raw
            tf
          else
            res.body
          end
        end
      elsif res.kind_of?(Net::HTTPFound) or res.kind_of?(Net::HTTPMovedPermanently)
        if res['set-cookie']
          @cookies["#{url.host}:#{url.port}"] = res['set-cookie']
        end
        run_request(:GET, create_url(res['location']), false, limit - 1, raw)
      else
        res.error!
      end
    end
  end
end
