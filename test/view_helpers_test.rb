require 'test_helper'

class ViewHelpersTest < ActionView::TestCase
  include Gretel::ViewHelpers

  setup do
    Gretel.reset!
    Gretel::Trails::UrlStore.secret = "84f3196275c50b6fee3053c7b609b2633143f33f3536cb74abdf2753cca5a3e24b9dd93e4d7c75747c2f111821c7feb0e51e13485e4d772c17f60c1f8d832b72"
  end

  test "trail helper" do
    breadcrumb :about

    assert_equal "aec19c5388f02dd60151589ad01b4f3ec074598e_W1siYWJvdXQiLCJBYm91dCIsMCwiL2Fib3V0Il1d", breadcrumb_trail
  end

  test "loading trail" do
    params[:trail] = "aec19c5388f02dd60151589ad01b4f3ec074598e_W1siYWJvdXQiLCJBYm91dCIsMCwiL2Fib3V0Il1d"
    breadcrumb :recent_products

    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <span class="current">Recent products</span></div>},
                 breadcrumbs
  end

  test "different trail param" do
    Gretel::Trails.trail_param = :mytest
    params[:mytest] = "aec19c5388f02dd60151589ad01b4f3ec074598e_W1siYWJvdXQiLCJBYm91dCIsMCwiL2Fib3V0Il1d"
    breadcrumb :recent_products

    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <span class="current">Recent products</span></div>},
                 breadcrumbs
  end

  test "unknown trail" do
    params[:trail] = "notfound"
    breadcrumb :recent_products

    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Recent products</span></div>},
                 breadcrumbs
  end
end