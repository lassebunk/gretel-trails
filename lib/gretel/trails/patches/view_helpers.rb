Gretel::ViewHelpers.class_eval do
  # Encoded breadcrumb trail to be used in URLs.
  def breadcrumb_trail
    gretel_renderer.trail
  end

  # Yields a block having the breadcrumb trail set to the breadcrumb given by +key+.
  def with_breadcrumb_trail(key, *args, &block)
    with_breadcrumb(key, *args) do
      gretel_renderer.transform_current_path = false
      yield
    end
  end
end