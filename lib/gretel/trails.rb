require "gretel"
require "gretel/trails/version"
require "gretel/trails/engine"

module Gretel
  module Trails
    class << self
      # Activated strategies
      def strategies
        @strategies ||= []
      end

      # Activates strategies. Can be either a symbol or array of symbols.
      # 
      #   Gretel::Trails.strategies = :hidden
      #   Gretel::Trails.strategies = [:hidden, :other_strategy]
      def strategies=(value)
        @strategies = [value].flatten
        @strategies.each { |s| require "gretel/trails/strategies/#{s}_strategy"}
      end

      alias_method :strategy=, :strategies=
    end
  end
end