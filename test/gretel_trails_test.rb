require 'test_helper'

class GretelTrailsTest < ActionDispatch::IntegrationTest
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
    visit "/products/recent"

    within "#products" do
      click_link "Product One"
    end
    assert_equal "/products/one", current_fullpath
    assert_equal ["/", "/products/recent"], all(".breadcrumbs a").map { |a| a[:href] }

    click_link "See reviews"
    assert_equal "/products/one/reviews", current_fullpath
    assert_equal ["/", "/products/recent", "/products/one"], all(".breadcrumbs a").map { |a| a[:href] }

    all(".breadcrumbs a").last.click
    assert_equal "/products/one", current_fullpath
    assert_equal ["/", "/products/recent"], all(".breadcrumbs a").map { |a| a[:href] }

    all(".breadcrumbs a").last.click
    assert_equal "/products/recent", current_fullpath
  end
end
