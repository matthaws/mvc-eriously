require_relative "./xanthus/controllers/controller_base.rb"
require_relative "./xanthus/cookies/session.rb"
require_relative "./xanthus/cookies/flash.rb"
require_relative "./xanthus/middleware/exceptions.rb"
require_relative "./xanthus/routes/router.rb"
require_relative "./xanthus/routes/route.rb"
require_relative "./xanthus/db/db_connection.rb"
require_relative "./xanthus/models/model_base.rb"

require "xanthus/version"

# frozen_string_literal: true
module Xanthus
  attr_accessor :router

  def server(router, port = 3000)
    app_proc = Proc.new do |env|
      req = Rack::Request.new(env)
      res = Rack::Response.new
      router.run(req, res)
      res.finish
    end

    app = Rack::Builder.new do
      use ShowExceptions
      use Static
      run app_proc
    end

    Rack::Server.start(
     app: app,
     Port: port
    )
  end

  class ControllerBase
  end

  class ModelBase
  end

  class Router
  end

  private

  class DBConnection
  end

  class Route
  end

  class Session
  end

  class Flash
  end

  class ShowExceptions
  end
end
