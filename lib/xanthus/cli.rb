require "thor"
require "xanthus"
require "rack"

module Xanthus
  class CLI < Thor
    def new(project_name)
      commands = [
        `mkdir #{project_name}`,
        `mkdir #{project_name}/routes`,
        `mkdir #{project_name}/controllers`,
        `mkdir #{project_name}/views`,
        `mkdir #{project_name}/models`
      ]

    end

    def server(port = 3000)
      router = Xanthus::Router.create
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
      end.to_app

      Rack::Server.start(
       app: app,
       Port: port
      )
    end
  end
end
