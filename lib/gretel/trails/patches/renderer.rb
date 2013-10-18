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
    @trail ||= Gretel::Trails.encode(links)
  end
end