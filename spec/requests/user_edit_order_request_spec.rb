require 'rails_helper'

describe "Usuário edita pedido" do
  it 'e não é o dono' do
    # Arrange
    joao = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    carla = User.create!(name: 'Carla', email: 'carla@email.com', password: 'password')
    
    warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')
 
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                                registration_number: '433332323',
                                full_address: 'Av. das Palmas, 100', city: 'Bauru',
                                state: 'SP', email: 'contato@acme.com')
    
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier,
                                estimated_delivery_date: 1.day.from_now)
    # Act
    login_as(carla)
    patch(order_path(order.id), params: { order: { supplier_id: 3}})

    # Assert
    expect(response).to redirect_to(root_path)
  end
end