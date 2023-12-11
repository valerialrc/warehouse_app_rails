require 'rails_helper'

describe 'Usuário informa novo status de pedido' do
  it 'e pedido foi entregue' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    
    warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')
 
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                                registration_number: '433332323',
                                full_address: 'Av. das Palmas, 100', city: 'Bauru',
                                state: 'SP', email: 'contato@acme.com')

    product = ProductModel.create!(name: 'Produto A', weight: 15, width: 10,
                                height: 20, depth: 30, supplier: supplier, sku: 'PRODUTOA')
    
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier,
                                estimated_delivery_date: 1.day.from_now, status: :pending)


    order_item = OrderItem.create!(product_model: product, order: order, quantity: 5)

    # Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Marcar como ENTREGUE'

    # Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Status do Pedido: Entregue'
    expect(page).not_to have_content 'Marcar como CANCELADO'
    expect(page).not_to have_content 'Marcar como ENTREGUE'
    expect(StockProduct.where(product_model: product, warehouse: warehouse).count).to eq 5
  end

  it 'e pedido foi cancelado' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
  
    warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')
  
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                                registration_number: '433332323',
                                full_address: 'Av. das Palmas, 100', city: 'Bauru',
                                state: 'SP', email: 'contato@acme.com')
    
    product = ProductModel.create!(name: 'Produto A', weight: 15, width: 10,
                                height: 20, depth: 30, supplier: supplier, sku: 'PRODUTOA')
    
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier,
                                estimated_delivery_date: 1.day.from_now, status: :pending)


    order_item = OrderItem.create!(product_model: product, order: order, quantity: 5)

    # Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Marcar como CANCELADO'

    # Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Status do Pedido: Cancelado'
    expect(StockProduct.count).to eq 0
  end
end