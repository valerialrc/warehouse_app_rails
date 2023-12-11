require 'rails_helper'

describe "Usuário busca por um pedido" do
  it 'a partir do menu' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')

    # Act
    login_as(user)
    visit root_path

    # Assert
    within('header nav') do
      expect(page).to have_field 'Buscar Pedido'
      expect(page).to have_button('Buscar')
    end
  end

  it 'e deve estar autenticado' do
    # Arrange

    # Act
    visit root_path

    # Assert
    within('header nav') do
      expect(page).not_to have_field 'Buscar Pedido'
      expect(page).not_to have_button('Buscar')
    end
  
  end

  it 'e encontra um pedido' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    
    warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')
   
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                                registration_number: '433332323',
                                full_address: 'Av. das Palmas, 100', city: 'Bauru',
                                state: 'SP', email: 'contato@acme.com')
        
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier,
                          estimated_delivery_date: 1.day.from_now)

    # Act
    login_as(user)
    visit root_path
    fill_in 'Buscar Pedido', with: order.code
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultados da Busca por: #{order.code}"
    expect(page).to have_content '1 pedido encontrado'
    expect(page).to have_content "Código: #{order.code}"
    expect(page).to have_content 'Galpão Destino: MCZ | Maceio'
    expect(page).to have_content 'Fornecedor: ACME LTDA'
  end

  it 'e encontra múltiplos pedidos' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    
    first_warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                        area: 50_000, address: 'Rua Três, 2000',
                                        cep: '33000-001', description: 'Galpão de Maceio')

    second_warehouse = Warehouse.create!(name: 'BH', code: 'BHZ', city: 'Belo Horizonte',
                                         area: 20_000, address: 'Rua Dois, 55', cep: '35000-777',
                                         description: 'Galpão de BH')
   
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                                registration_number: '433332323',
                                full_address: 'Av. das Palmas, 100', city: 'Bauru',
                                state: 'SP', email: 'contato@acme.com')
    
    allow(SecureRandom).to receive(:alphanumeric).and_return('MCZ12345')
    first_order = Order.create!(user: user, warehouse: first_warehouse, supplier: supplier,
                                estimated_delivery_date: 1.day.from_now)

    allow(SecureRandom).to receive(:alphanumeric).and_return('MCZ65432')
    second_order = Order.create!(user: user, warehouse: first_warehouse, supplier: supplier,
                                 estimated_delivery_date: 1.day.from_now)

    allow(SecureRandom).to receive(:alphanumeric).and_return('BHZ12345')
    third_order = Order.create!(user: user, warehouse: second_warehouse, supplier: supplier,
                                estimated_delivery_date: 1.day.from_now)

    # Act
    login_as(user)
    visit root_path
    fill_in 'Buscar Pedido', with: 'MCZ'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content '2 pedidos encontrados'
    expect(page).to have_content 'MCZ12345'
    expect(page).to have_content 'MCZ65432'
    expect(page).not_to have_content 'BHZ12345'
    expect(page).to have_content 'Galpão Destino: MCZ | Maceio'
    expect(page).not_to have_content 'Galpão Destino: BHZ | BH'
  
  end
  
end
