require 'rails_helper'

describe "Usuário adiciona itens ao pedido" do
  it 'com sucesso' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')

    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                                registration_number: '433332323',
                                full_address: 'Av. das Palmas, 100', city: 'Bauru',
                                state: 'SP', email: 'contato@acme.com')

    product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10,
                                     height: 20, depth: 30, supplier: supplier, sku: 'PRODUTOA')

    product_b = ProductModel.create!(name: 'Produto B', weight: 15, width: 10,
                                     height: 20, depth: 30, supplier: supplier, sku: 'PRODUTOB')
    
    warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')
    
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier,
                                estimated_delivery_date: 1.day.from_now)

    # Act
    login_as user
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar Item'
    select 'Produto A', from: 'Produto'
    fill_in "Quantidade",	with: "8"
    click_on 'Gravar' 

    # Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Item adicionado com sucesso'
    expect(page).to have_content '8 x Produto A'
  end

  it 'e não vê produtos de outro fornecedor' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')

    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                                registration_number: '433332323',
                                full_address: 'Av. das Palmas, 100', city: 'Bauru',
                                state: 'SP', email: 'contato@acme.com')

    other_supplier = Supplier.create!(corporate_name: 'Spark LTDA', brand_name: 'Spark',
                                      registration_number: '55656555',
                                      full_address: 'Torre da Industria, 1', city: 'Teresina',
                                      state: 'PI', email: 'contato@spark.com')

    product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10,
                                     height: 20, depth: 30, supplier: supplier, sku: 'PRODUTOA')

    product_b = ProductModel.create!(name: 'Produto B', weight: 15, width: 10,
                                     height: 20, depth: 30, supplier: other_supplier, sku: 'PRODUTOB')
    
    warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')
    
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier,
                                estimated_delivery_date: 1.day.from_now)

    # Act
    login_as user
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar Item'

    # Assert
    expect(page).to have_content 'Produto A'
    expect(page).not_to have_content 'Produto B'
  end
end