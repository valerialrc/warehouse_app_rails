require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    it 'deve ter um código' do
      # Arrange
      user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')

      warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                    area: 50_000, address: 'Rua Três, 2000',
                                    cep: '33000-001', description: 'Galpão de Maceio')

      supplier = Supplier.create!(corporate_name: 'SAMSUNG LTDA',
                                  brand_name: 'Samsung', registration_number: '477777',
                                  full_address: 'Av. das Nações Unidas, 100',
                                  city: 'São Paulo', state: 'SP',
                                  email: 'contato@samsung.com')

      order = Order.new(user: user, supplier: supplier, warehouse: warehouse,
                        estimated_delivery_date: '2024-12-01')

      # Act
      result = order.valid?

      # Assert
      expect(result).to be true
    end

    it 'data estimada de entrega deve ser obrigatória' do
      # Arrange
      order = Order.new(estimated_delivery_date: '')

      # Act
      order.valid?
      result = order.errors.include?(:estimated_delivery_date)

      # Assert
      expect(result).to be true
    end

    it 'data estimada de entrega não deve ser passada' do
      # Arrange
      order = Order.new(estimated_delivery_date: 1.day.ago)
     
      # Act
      order.valid?
      result = order.errors.include?(:estimated_delivery_date)

      # Assert
      expect(result).to be true
      expect(order.errors[:estimated_delivery_date]).to include "deve ser futura."
    end

    it 'data estimada de entrega deve ser igual ou maior que amanhã' do
      # Arrange
      order = Order.new(estimated_delivery_date: 1.day.from_now)
     
      # Act
      order.valid?
      result = order.errors.include?(:estimated_delivery_date)

      # Assert
      expect(result).to be false
    end
  end

  describe 'gera um código aleatório' do
    it 'ao criar um novo pedido' do
      # Arrange
      user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')

      warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                    area: 50_000, address: 'Rua Três, 2000',
                                    cep: '33000-001', description: 'Galpão de Maceio')

      supplier = Supplier.create!(corporate_name: 'SAMSUNG LTDA',
                                  brand_name: 'Samsung', registration_number: '477777',
                                  full_address: 'Av. das Nações Unidas, 100',
                                  city: 'São Paulo', state: 'SP',
                                  email: 'contato@samsung.com')

      order = Order.new(user: user, supplier: supplier, warehouse: warehouse,
                        estimated_delivery_date: '2024-12-01')

      # Act
      order.save!
      result = order.code

      # Assert
      expect(result).not_to be_empty
      expect(result.length).to eq 8
    end

    it 'e o código é único' do
      # Arrange
      user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')

      warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                    area: 50_000, address: 'Rua Três, 2000',
                                    cep: '33000-001', description: 'Galpão de Maceio')

      supplier = Supplier.create!(corporate_name: 'SAMSUNG LTDA',
                                  brand_name: 'Samsung', registration_number: '477777',
                                  full_address: 'Av. das Nações Unidas, 100',
                                  city: 'São Paulo', state: 'SP',
                                  email: 'contato@samsung.com')

      first_order = Order.create!(user: user, supplier: supplier, warehouse: warehouse,
                                  estimated_delivery_date: '2024-10-01')

      second_order = Order.new(user: user, supplier: supplier, warehouse: warehouse,
                               estimated_delivery_date: '2024-11-15')
 
      # Act
      second_order.save!

      # Assert
      expect(second_order.code).not_to eq first_order.code
    end

    it 'e não deve ser modificado' do
      # Arrange
      user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')

      warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                    area: 50_000, address: 'Rua Três, 2000',
                                    cep: '33000-001', description: 'Galpão de Maceio')

      supplier = Supplier.create!(corporate_name: 'SAMSUNG LTDA',
                                  brand_name: 'Samsung', registration_number: '477777',
                                  full_address: 'Av. das Nações Unidas, 100',
                                  city: 'São Paulo', state: 'SP',
                                  email: 'contato@samsung.com')

      order = Order.create!(user: user, supplier: supplier, warehouse: warehouse,
                        estimated_delivery_date: 1.week.from_now)

      original_code = order.code

      # Act
      order.update!(estimated_delivery_date: 1.month.from_now)

      # Assert
      expect(order.code).to eq original_code
    end
  end
end