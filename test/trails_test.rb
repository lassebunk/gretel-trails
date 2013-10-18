require 'test_helper'

class TrailsTest < ActiveSupport::TestCase
  setup do
    Gretel.reset!
  end

  test "defaults" do
    assert_equal :trail, Gretel::Trails.trail_param
  end

  test "setting invalid store" do
    assert_raises ArgumentError do
      Gretel::Trails.store = :xx
    end
  end

  test "setting store options on main module" do
    assert_equal :trail, Gretel.trail_param
    Gretel.trail_param = :other_param
    assert_equal :other_param, Gretel::Trail.trail_param

    assert_equal Gretel::Trails::UrlStore, Gretel::Trails.trail_store
    Gretel.trail_store = :redis
    assert_equal Gretel::Trails::RedisStore, Gretel::Trail.store
  end
end