require 'json'

# frozen_string_literal: true

class Flash
  def initialize(req)
    @flash_cookie = req.cookies['_xanthus_app']
    @flash_now = {}

    if @flash_cookie
      @flash_cookie = JSON.parse(@flash_cookie)
      @start_cookie = {}
      @flash_cookie.each do |k, v|
        @start_cookie[k] = v
      end
    else
      @flash_cookie = {}
    end
  end

  def [](key)
    return @flash_now[key] if @flash_now[key]
    @flash_cookie[key.to_sym] || @flash_cookie[key.to_s]
  end

  def []=(key, val)
    @flash_cookie[key.to_sym] = val
  end

  def now
    @flash_now
  end

  def store_flash(res)
    if @start_cookie
      @start_cookie.each do |k, v|
        @flash_cookie.delete(k)
      end
    end

    result_cookie = { path: "/", value: @flash_cookie.to_json}
    res.set_cookie('_xanthus_app', result_cookie)
  end
end
