require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative '../cookies/session'
require_relative '../cookies/flash'

# frozen_string_literal: true

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = req.params.merge(route_params)
    @already_rendered = false
  end

  def already_rendered?
    @already_rendered
  end

  def redirect_to(url)
    raise AlreadyRenderedError.new("Controller received multiple render commands") if already_rendered?
    @already_rendered = true
    res['Location'] = url
    res.status = 302
    self.session.store_session(res)
  end

  def render_content(content, content_type)
    raise AlreadyRenderedError.new("Controller received multiple render commands") if already_rendered?
    @already_rendered = true
    res['Content-Type'] = content_type
    res.write(content)
    self.session.store_session(res)
  end

  def render(template_name)
    path = "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    erb_result = ERB.new(File.read(path)).result(binding)
    render_content(erb_result, 'text/html')
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_rendered?
  end
end

class AlreadyRenderedError < StandardError
end
