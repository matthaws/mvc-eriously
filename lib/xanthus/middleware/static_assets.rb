require 'rack'
require 'erb'

# frozen_string_literal: true

class Static

  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    if req.path.include?('/assets')
      res = get_file(req.path[7..-1])
    else
      res = app.call(env)
    end

    res
  end

  def get_file(path)
    res = Rack::Response.new
    extension = path[-4..-1]
    set_type(res, extension)

    if File.exist?(path)
      file_contents = File.read(path)
      res.write(file_contents)
    else
      res.status = 404
      erb_result = ERB.new(File.read('views/templates/404.html.erb')).result(binding)
      res.write(erb_result)
      res["Content-type"] = "text/html"
    end

    res
  end

  def set_type(res, extension)
    case extension
    when ".txt"
      res["Content-type"] = 'text/html'
    when ".jpg"
      res["Content-type"] = "image/jpeg"
    when ".zip"
      res["Content-type"] = "application/zip"
    end
  end
end
