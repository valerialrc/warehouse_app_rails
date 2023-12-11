class Warehouse < ApplicationRecord
  has_many :stock_products
  validates :name, :code, :description, :address, :city, :cep, :area, presence: true
  validates :code, uniqueness: true

  def full_description
    "#{code} | #{name}"
  end
end