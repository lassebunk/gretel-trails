Gretel::Renderer.class_eval do
  # Loads parent links from trail if +params[:trail]+ is present.
  def parent_links_for_with_trail(crumb)
    if params[Gretel::Trails.trail_param].present?
      Gretel::Trails.decode(params[Gretel::Trails.trail_param])
    else
      parent_links_for_without_trail(crumb)
    end
  end

  alias_method_chain :parent_links_for, :trail

  # Returns encoded trail for the breadcrumb.
  def trail
    @trail ||= begin
      transformed_links = links.dup
      if transform_current_path && transformed_links.any? && request
        transformed_links.last.url = request.fullpath
      end
      Gretel::Trails.encode(transformed_links)
    end
  end

  # Whether to set the current link path to +request.fullpath+.
  def transform_current_path
    return @transform_current_path if defined?(@transform_current_path)
    @transform_current_path = true
  end

  attr_writer :transform_current_path
end