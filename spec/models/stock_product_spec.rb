require 'rails_helper'

RSpec.describe StockProduct, type: :model do
  describe 'Gera um número de série' do
    it 'ao criar um StockProduct' do
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
                        estimated_delivery_date: 1.week.from_now, status: :delivered)

      product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10,
                        height: 20, depth: 30, supplier: supplier, sku: 'PRODUTOA')

      # Act
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product_a)

      # Assert
      expect(stock_product.serial_number.length).to eq 20
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

      product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10,
                        height: 20, depth: 30, supplier: supplier, sku: 'PRODUTOA')

      product_b = ProductModel.create!(name: 'Produto B', weight: 15, width: 10,
                        height: 20, depth: 30, supplier: supplier, sku: 'PRODUTOB')

      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product_a)

      original_serial_number = stock_product.serial_number

      # Act
      stock_product.update!(product_model: product_b)

      # Assert
      expect(stock_product.serial_number).to eq original_serial_number
    end
  end

  describe '#available' do
    it 'true se não tiver destino' do
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
                        estimated_delivery_date: 1.week.from_now, status: :delivered)

      product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10,
                        height: 20, depth: 30, supplier: supplier, sku: 'PRODUTOA')

      # Act
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product_a)

      # Assert
      expect(stock_product.available?).to eq true
    end

    it 'false se não tiver destino' do
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
                        estimated_delivery_date: 1.week.from_now, status: :delivered)

      product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10,
                        height: 20, depth: 30, supplier: supplier, sku: 'PRODUTOA')

      # Act
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product_a)
      stock_product.create_stock_product_destination(recipient: 'João', address: 'Rua Três')
      
      # Assert
      expect(stock_product.available?).to eq false
    end

  end
end
