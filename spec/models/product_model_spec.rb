require 'rails_helper'

RSpec.describe ProductModel, type: :model do
  describe '#valid?' do
    it 'name is mandatory' do
      # Arrange
      supplier = Supplier.create!(corporate_name: 'SAMSUNG LTDA',
                                  brand_name: 'Samsung',
                                  registration_number: '477777',
                                  full_address: 'Av. das Nações Unidas, 100',
                                  city: 'São Paulo', state: 'SP',
                                  email: 'contato@samsung.com')

      pm = ProductModel.new(name: '', weight: 8000, width: 70,
                            height: 45, depth: 10, sku: 'TV32-SAMSU',
                            supplier: supplier)

      # Act
      result = pm.valid?

      # Assert
      expect(result).to eq false
    end

    it 'sku is mandatory' do
      # Arrange
      supplier = Supplier.create!(corporate_name: 'SAMSUNG LTDA',
                                  brand_name: 'Samsung',
                                  registration_number: '477777',
                                  full_address: 'Av. das Nações Unidas, 100',
                                  city: 'São Paulo', state: 'SP',
                                  email: 'contato@samsung.com')

      pm = ProductModel.new(name: 'TV 32', weight: 8000, width: 70,
                            height: 45, depth: 10, sku: '',
                            supplier: supplier)

      # Act
      result = pm.valid?

      # Assert
      expect(result).to eq false
    end
  end
end
