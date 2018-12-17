class Sale < ApplicationRecord
  validates :seller_id, presence: true
  validates :product_id, presence: true
  validates :price, presence: true
  # belongs_to :products
  # belongs_to :sales
  # belongs_to :buyers
end
