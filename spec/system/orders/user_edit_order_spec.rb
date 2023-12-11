require 'rails_helper'

describe "Usuário edita pedido" do
  it 'e deve estar autenticado' do
    # Arrange
    joao = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    
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
    visit edit_order_path(order.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    # Arrange
    joao = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    
    warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')
 
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                                registration_number: '433332323',
                                full_address: 'Av. das Palmas, 100', city: 'Bauru',
                                state: 'SP', email: 'contato@acme.com')

    other_supplier = Supplier.create!(corporate_name: 'LG LTDA', brand_name: 'LG',
                                      registration_number: '22222222',
                                      full_address: 'Praça das Palmeiras, 110',
                                      city: 'São Paulo', state: 'SP',
                                      email: 'contato@lg.com')
    
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier,
                                estimated_delivery_date: 1.day.from_now)
    # Act
    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Editar'
    fill_in 'Data Prevista de Entrega', with: '12/12/2024'
    select 'LG LTDA', from: 'Fornecedor'
    click_on 'Gravar'

    # Assert
    expect(page).to have_content 'Pedido atualizado com sucesso.'
    expect(page).to have_content 'Fornecedor: LG LTDA'
    expect(page).to have_content 'Data Prevista de Entrega: 12/12/2024'
  end

  it 'caso seja o responsável' do
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
    visit edit_order_path(order.id)

    # Assert
    expect(current_path).to eq root_path
  end
end