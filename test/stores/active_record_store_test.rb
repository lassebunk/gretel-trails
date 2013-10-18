require 'test_helper'

class ActiveRecordStoreTest < ActiveSupport::TestCase
  setup do
    Gretel.reset!
    Gretel::Trails.store = :db
    Gretel::Trails.delete_all
    
    @links = [
      [:root, "Home", "/"],
      [:store, "Store <b>Test</b>".html_safe, "/store"],
      [:search, "Search", "/store/search?q=test"]
    ]
  end

  test "defaults" do
    assert_equal 1.day, Gretel::Trails::ActiveRecordStore.expires_in
  end

  test "encoding" do
    assert_equal "684c211441e72225cee89477a2d1f59e657c9e26",
                 Gretel::Trails.encode(@links.map { |key, text, url| Gretel::Link.new(key, text, url) })
  end

  test "decoding" do
    Gretel::Trails.encode(@links.map { |key, text, url| Gretel::Link.new(key, text, url) })
    decoded = Gretel::Trails.decode("684c211441e72225cee89477a2d1f59e657c9e26")
    assert_equal @links, decoded.map { |link| [link.key, link.text, link.url] }
    assert_equal [false, true, false], decoded.map { |link| link.text.html_safe? }
  end

  test "invalid trail" do
    assert_equal [], Gretel::Trails.decode("asdgasdg")
  end

  test "delete expired" do
    10.times { Gretel::Trails.encode([Gretel::Link.new(:test, SecureRandom.hex(20), "/test")]) }
    assert_equal 10, Gretel::Trails.count
    
    Gretel::Trails.delete_expired
    assert_equal 10, Gretel::Trails.count

    Timecop.travel(14.hours.from_now) do
      5.times { Gretel::Trails.encode([Gretel::Link.new(:test, SecureRandom.hex(20), "/test")]) }
      assert_equal 15, Gretel::Trails.count
    end

    Timecop.travel(25.hours.from_now) do
      Gretel::Trails.delete_expired
      assert_equal 5, Gretel::Trails.count
    end
  end
end