class Supplier < ApplicationRecord
  has_many :product_models
  validates :brand_name, :corporate_name, :registration_number, :full_address, :city, :state, :email, presence: true
end
