class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    @pattern =~ req.path && @http_method == req.request_method.downcase.to_sym
  end

  def run(req, res)
    params = @pattern.match(req.path)
    params = {} if params.names.length == 0
    controller = @controller_class.new(req, res, params)
    controller.invoke_action(self.action_name)
  end
end
