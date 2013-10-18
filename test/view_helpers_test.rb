require 'test_helper'

class HelperMethodsTest < ActionView::TestCase
  include Gretel::ViewHelpers

  setup do
    Gretel.reset!
  end

  test "trail helper" do
    breadcrumb :basic

    assert_equal "667ea523f92bdb3a086494575b18f587170e482b_W1siYmFzaWMiLCJBYm91dCIsMCwiL2Fib3V0Il1d", breadcrumb_trail
  end

  test "loading trail" do
    params[:trail] = "667ea523f92bdb3a086494575b18f587170e482b_W1siYmFzaWMiLCJBYm91dCIsMCwiL2Fib3V0Il1d"
    breadcrumb :multiple_links

    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <a href="/about/contact">Contact</a> &rsaquo; <span class="current">Contact form</span></div>},
                 breadcrumbs
  end

  test "different trail param" do
    Gretel.trail_param = :mytest
    params[:mytest] = "667ea523f92bdb3a086494575b18f587170e482b_W1siYmFzaWMiLCJBYm91dCIsMCwiL2Fib3V0Il1d"
    breadcrumb :multiple_links

    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <a href="/about/contact">Contact</a> &rsaquo; <span class="current">Contact form</span></div>},
                 breadcrumbs
  end

  test "unknown trail" do
    params[:trail] = "notfound"
    breadcrumb :multiple_links

    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about/contact">Contact</a> &rsaquo; <span class="current">Contact form</span></div>},
                 breadcrumbs
  end
end