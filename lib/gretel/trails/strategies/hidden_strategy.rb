module Gretel
  module Trails
    module HiddenStrategy
      DEFAULT_JS_SELECTOR = ".js-append-trail"
      DEFAULT_DATA_ATTRIBUTE = "trail"

      class << self
        # jQuery selector for links that should have the trail appended
        # to them on click. Default: +.js-append-trail+
        def js_selector
          @js_selector ||= DEFAULT_JS_SELECTOR
        end

        # Sets the jQuery link selector.
        attr_writer :js_selector

        # Name of the HTML data attribute that will contain the trail
        # when it is hidden. Default: +trail+
        def data_attribute
          @data_attribute ||= DEFAULT_DATA_ATTRIBUTE
        end

        # Sets the HTML data attribute.
        attr_writer :data_attribute
      end
    end
  end
end

Gretel::Renderer.class_eval do
  # Moves the trail from the querystring into a data attribute.
  def render_link_with_hidden_trail(name, url, options = {})
    if url.include?("#{Gretel::Trail.trail_param}=")
      uri = URI.parse(url)
      query_hash = Hash[CGI.parse(uri.query.to_s).map { |k, v| [k, v.first] }]
      trail = query_hash.delete(Gretel::Trail.trail_param.to_s)

      options = options.dup
      options[:data] ||= {}
      options[:data][Gretel::Trails::HiddenStrategy.data_attribute] = trail

      uri.query = query_hash.to_query.presence
      url = uri.to_s
    end
    render_link_without_hidden_trail(name, url, options)
  end

  alias_method_chain :render_link, :hidden_trail
end