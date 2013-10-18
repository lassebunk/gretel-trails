crumb :root do
  link "Home", root_path
end

crumb :about do
  link "About", about_path
end

crumb :category do |category|
  link category.name, category
end

crumb :product do |product|
  link product.name, product
  parent :category, product.category
end

crumb :product_reviews do |product|
  link "Reviews", product_reviews_path(product)
  parent :product, product
end

crumb :recent_products do
  link "Recent products", recent_products_path
end