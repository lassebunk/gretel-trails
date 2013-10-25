require "gretel"
require "gretel/trails/stores"
require "gretel/trails/tasks"
require "gretel/trails/patches"
require "gretel/trails/version"
require "gretel/trails/engine"

module Gretel
  module Trails
    DEFAULT_STORES = {
      url: UrlStore,
      db: ActiveRecordStore,
      redis: RedisStore
    }

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

      # Gets the store that is used to encode and decode trails.
      # Default: +Gretel::Trails::UrlStore+
      def store
        @store ||= UrlStore
      end

      # Sets the store that is used to encode and decode trails.
      # Can be a subclass of +Gretel::Trails::Store+, or a symbol: +:url+, +:db+, or +:redis+.
      def store=(value)
        if value.is_a?(Symbol)
          klass = available_stores[value]
          raise ArgumentError, "Unknown Gretel::Trails.store #{value.inspect}. Use any of #{available_stores.inspect}." unless klass
          self.store = klass
        else
          @store = value
        end
      end

      # Registers a store for use with `Gretel::Trails.store = :key`.
      #
      #   Gretel::Trails.register_store :url, UrlStore
      def register_store(key, klass)
        available_stores[key] = klass
      end

      # Hash of registered stores.
      def available_stores
        @available_stores ||= DEFAULT_STORES
      end

      # Uses the store to encode an array of links to a unique key that can be used in URLs.
      def encode(links)
        store.encode(links)
      end

      # Uses the store to decode a unique key to an array of links.
      def decode(key)
        store.decode(key)
      end

      # Deletes expired keys from the store.
      # Not all stores support expiring keys, and will raise an exception if they don't.
      def delete_expired
        store.delete_expired
      end

      # Returns the current number of trails in the store.
      # Not all stores support counting keys, and will raise an exception if they don't.
      def count
        store.key_count
      end

      # Deletes all trails in the store.
      # Not all stores support deleting trails, and will raise an exception if they don't.
      def delete_all
        store.delete_all_keys
      end

      # Name of trail param. Default: +:trail+.
      def trail_param
        @trail_param ||= :trail
      end
      
      # Sets the trail param.
      attr_writer :trail_param

      # Yields +self+ for configuration.
      # 
      #   Gretel::Trails.configure do |config|
      #     config.store = :db
      #     config.strategy = :hidden
      #   end
      def configure
        yield self
      end

      # Resets all changes made to +Gretel::Trails+. Used for testing.
      def reset!
        instance_variables.each { |var| remove_instance_variable var }
        available_stores.each_value(&:reset!)
      end
    end
  end
end