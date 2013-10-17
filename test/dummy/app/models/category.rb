class Category < ActiveRecord::Base
  has_many :products

  def self.find(*args)
    find_by_slug(*args) || super
  end

  def to_param
    slug
  end
end
