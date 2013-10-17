class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
  end

  def reviews
    @product = Product.find(params[:product_id])
  end

  def recent
    @products = Product.order("id DESC")
  end
end
