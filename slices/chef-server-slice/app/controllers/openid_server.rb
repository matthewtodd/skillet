# MonkeyPatching ChefServerSlice::OpenidServer to bugfix: merb content_type is a symbol
class ChefServerSlice::OpenidServer < ChefServerSlice::Application
  def index

    oidreq = server.decode_request(params.reject{|k,v| k == "controller" || k == "action"})

    # no openid.mode was given
    unless oidreq
      return "This is the Chef OpenID server endpoint."
    end

    oidresp = nil

    if oidreq.kind_of?(CheckIDRequest)
      identity = oidreq.identity

      if oidresp
        nil
      elsif self.is_authorized(identity, oidreq.trust_root)
        oidresp = oidreq.answer(true, nil, identity)
      elsif oidreq.immediate
        server_url = slice_url :openid_server
        oidresp = oidreq.answer(false, server_url)
      else
        if content_type == :json
          session[:last_oidreq] = oidreq
          response = { :action => slice_url(:openid_server_decision) }
          return response.to_json
        else
          return show_decision_page(oidreq)
        end
      end
    else
      oidresp = server.handle_request(oidreq)
    end

    self.render_response(oidresp)
  end
end
