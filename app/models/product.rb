class Product < ApplicationRecord
  has_many :sales
  validates :name, presence: true, uniqueness: {case_sensitivity: false}
  validates :description, presence: true
  validates :category_id, presence: true
end

