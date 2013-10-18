Gretel::ViewHelpers.class_eval do
  # Encoded breadcrumb trail to be used in URLs.
  def breadcrumb_trail
    gretel_renderer.trail
  end
end