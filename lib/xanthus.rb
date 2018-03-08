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
  
  def setup_routes
    @router = Router.instance_eval
  end
  class ControllerBase
  end

  class ModelBase
  end

  private
  class Router
  end

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
