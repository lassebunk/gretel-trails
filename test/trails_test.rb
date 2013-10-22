require 'test_helper'

class TrailsTest < ActiveSupport::TestCase
  setup do
    Gretel.reset!
  end

  test "defaults" do
    assert_equal :trail, Gretel::Trails.trail_param
  end

  test "configuration block" do
    Gretel::Trails.configure do |config|
      config.store = :url
      config.store.secret = "1234"
      config.trail_param = :set_from_config
    end

    assert_equal :set_from_config, Gretel::Trails.trail_param
    assert_equal "1234", Gretel::Trails::UrlStore.secret
  end

  test "setting invalid store" do
    assert_raises ArgumentError do
      Gretel::Trails.store = :xx
    end
  end
end