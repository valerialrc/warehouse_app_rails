class Warehouse < ApplicationRecord
  validates :name, :code, :description, :address, :city, :cep, :area, presence: true
  validates :code, uniqueness: true
end