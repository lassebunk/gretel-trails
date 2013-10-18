Gretel.class_eval do
  class << self
    # Adds +Trails.reset!+ to +Gretel.reset!+.
    def reset_with_trails!
      reset_without_trails!
      Gretel::Trails.reset!
    end

    alias_method_chain :reset!, :trails
  end
end