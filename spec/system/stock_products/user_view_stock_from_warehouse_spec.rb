require 'rails_helper'

describe "Usuário vê o estoque" do
  it 'na tela do galpão' do
    # Arrange
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                                registration_number: '433332323',
                                full_address: 'Av. das Palmas, 100', city: 'Bauru',
                                state: 'SP', email: 'contato@acme.com')

    warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')

    product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10,
                                     height: 20, depth: 30, supplier: supplier, sku: 'PRODUTOA')

    product_b = ProductModel.create!(name: 'Produto B', weight: 15, width: 10,
                                     height: 20, depth: 30, supplier: supplier, sku: 'PRODUTOB')

    product_c = ProductModel.create!(name: 'Produto C', weight: 15, width: 10,
                                     height: 20, depth: 30, supplier: supplier, sku: 'PRODUTOC')

    joao = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
                                     
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier,
                                 estimated_delivery_date: 1.day.from_now)

    3.times{StockProduct.create!(order: order, warehouse: warehouse, product_model: product_a)}
    2.times{StockProduct.create!(order: order, warehouse: warehouse, product_model: product_b)}

    # Act
    login_as(joao)
    visit root_path
    click_on 'Maceio'

    # Assert
    within('section#stock_products') do
      expect(page).to have_content 'Itens em Estoque'
      expect(page).to have_content '3 x PRODUTOA'
      expect(page).to have_content '2 x PRODUTOB'
      expect(page).not_to have_content 'PRODUTOC'
    end
  end

  it 'e dá baixa em um item' do
    # Arrange
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                                registration_number: '433332323',
                                full_address: 'Av. das Palmas, 100', city: 'Bauru',
                                state: 'SP', email: 'contato@acme.com')

    warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')

    product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10,
                                     height: 20, depth: 30, supplier: supplier, sku: 'PRODUTOA')

    joao = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
                                     
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier,
                                 estimated_delivery_date: 1.day.from_now)

    2.times{StockProduct.create!(order: order, warehouse: warehouse, product_model: product_a)}

    # Act
    login_as(joao)
    visit root_path
    click_on 'Maceio'
    select 'PRODUTOA', from: 'Item para Saída'
    fill_in "Destinatário",	with: "Maria Ferreira"
    fill_in 'Endereço Destino', with: 'Rua das Palmeiras - 100 - Campinas - São Paulo'
    click_on 'Confirmar Retirada' 

    # Assert
    expect(current_path).to eq warehouse_path(warehouse.id)
    expect(page).to have_content 'Item retirado com sucesso'
    expect(page).to have_content '1 x PRODUTOA'
  end
end