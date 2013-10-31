require 'test_helper'

class GretelTrailsTest < ActionDispatch::IntegrationTest
  setup do
    Gretel.reset!
    Gretel::Trails.configure do |config|
      config.store = :db
      config.strategy = :hidden
    end
  end

  test "configuration block" do
    Gretel::Trails.configure do |config|
      config.hidden.js_selector = ".test"
    end

    assert_equal ".test", Gretel::Trails::HiddenStrategy.js_selector
  end

  test "regular breadcrumbs" do
    visit "/categories/one"

    within "#products" do
      click_link "Product One"
    end
    assert_equal "/products/one", current_fullpath
    assert_equal ["/", "/categories/one"], all(".breadcrumbs a").map { |a| a[:href] }

    click_link "See reviews"
    assert_equal "/products/one/reviews", current_fullpath
    assert_equal ["/", "/categories/one", "/products/one"], all(".breadcrumbs a").map { |a| a[:href] }

    all(".breadcrumbs a").last.click
    assert_equal "/products/one", current_fullpath
    assert_equal ["/", "/categories/one"], all(".breadcrumbs a").map { |a| a[:href] }

    all(".breadcrumbs a").last.click
    assert_equal "/categories/one", current_fullpath
  end

  test "invisibly applying trail" do
    visit "/products/recent?page=2"

    within "#products" do
      click_link "Product One"
    end
    assert_equal "/products/one", current_fullpath
    assert_equal ["/", "/products/recent?page=2"], all(".breadcrumbs a").map { |a| a[:href] }

    click_link "See reviews"
    assert_equal "/products/one/reviews", current_fullpath
    assert_equal ["/", "/products/recent?page=2", "/products/one"], all(".breadcrumbs a").map { |a| a[:href] }

    all(".breadcrumbs a").last.click
    assert_equal "/products/one", current_fullpath
    assert_equal ["/", "/products/recent?page=2"], all(".breadcrumbs a").map { |a| a[:href] }

    all(".breadcrumbs a").last.click
    assert_equal "/products/recent?page=2", current_fullpath
  end

  test "breadcrumb_link_to" do
    visit "/products/recent"

    within "#products" do
      click_link "Product One"
    end

    click_link "See reviews"

    within "#back" do
      click_link "Back"
    end

    assert_equal "/products/one", current_fullpath

    within "#back" do
      click_link "Back"
    end

    assert_equal "/products/recent", current_fullpath
  end
end
