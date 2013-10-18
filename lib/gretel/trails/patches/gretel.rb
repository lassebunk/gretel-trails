Gretel.class_eval do
  # Adds +Trails.reset!+ to +Gretel.reset!+.
  def reset_with_trails!
    reset_without_trails!
    Trails.reset!
  end

  alias_method_chain :reset!, :trails
end