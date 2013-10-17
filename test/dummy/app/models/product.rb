class Product < ActiveRecord::Base
  belongs_to :category

  def self.find(*args)
    find_by_slug(*args) || super
  end

  def to_param
    slug
  end
end
