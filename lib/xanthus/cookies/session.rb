require 'json'

# frozen_string_literal: true

class Session
  def initialize(req)
    @session_cookie = req.cookies['_xanthus_app']
    if @session_cookie
      @session_cookie = JSON.parse(@session_cookie)
    else
      @session_cookie = {}
    end
  end

  def [](key)
    @session_cookie[key]
  end

  def []=(key, val)
    @session_cookie[key] = val
  end

  def store_session(res)
    result_cookie = { path: "/", value: @session_cookie.to_json}
    res.set_cookie('_xanthus_app', result_cookie)
  end
end
