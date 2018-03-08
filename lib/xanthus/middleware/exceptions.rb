require 'erb'
require 'rack'

# frozen_string_literal: true

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      app.call(env)
    rescue => e
      render_exception(e)
    end
  end

  private

  def render_exception(e)
    path = "views/templates/rescue.html.erb"
    res = Rack::Response.new
    res.status = "500"
    @error = e
    erb_result = ERB.new(File.read(path)).result(binding)
    res['Content-type'] = 'text/html'
    res.write(erb_result)
    res.finish
  end

end
