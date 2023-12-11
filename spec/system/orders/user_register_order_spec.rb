require 'rails_helper'

describe 'Usuário cadastra um pedido' do
  it 'e deve estar autenticado' do
    # Arrange

    # Act
    visit root_path
    click_on 'Registrar Pedido'

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')

    Warehouse.create!(name: 'BH', code: 'BHZ', city: 'Belo Horizonte',
                      area: 20_000, address: 'Rua Dois, 55', cep: '35000-777',
                      description: 'Galpão de BH')

    
    warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')
   
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                                registration_number: '433332323',
                                full_address: 'Av. das Palmas, 100', city: 'Bauru',
                                state: 'SP', email: 'contato@acme.com')
             
    Supplier.create!(corporate_name: 'Spark LTDA', brand_name: 'Spark',
                    registration_number: '55656555',
                    full_address: 'Torre da Industria, 1', city: 'Teresina',
                    state: 'PI', email: 'contato@spark.com')
             
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC12345')
    
    # Act
    login_as(user)
    visit root_path
    click_on 'Registrar Pedido'
    select 'MCZ | Maceio', from: 'Galpão Destino'
    select supplier.corporate_name, from: 'Fornecedor'
    fill_in 'Data Prevista de Entrega', with: '20/12/2024'
    click_on 'Gravar'

    # Assert
    expect(page).to have_content 'Pedido registrado com sucesso.'
    expect(page).to have_content 'Pedido ABC12345'
    expect(page).to have_content 'Galpão Destino: MCZ | Maceio'
    expect(page).to have_content 'Fornecedor: ACME LTDA'
    expect(page).to have_content 'Usuário Responsável: João - joao@email.com'
    expect(page).to have_content 'Data Prevista de Entrega: 20/12/2024'
    expect(page).to have_content 'Status do Pedido: Pendente'
    expect(page).not_to have_content 'BH'
  end

  it 'e não informa a data de entrega' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    
    warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')
   
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                                registration_number: '433332323',
                                full_address: 'Av. das Palmas, 100', city: 'Bauru',
                                state: 'SP', email: 'contato@acme.com')

    # Act
    login_as(user)
    visit root_path
    click_on 'Registrar Pedido'
    select 'MCZ | Maceio', from: 'Galpão Destino'
    select supplier.corporate_name, from: 'Fornecedor'
    fill_in 'Data Prevista de Entrega', with: ''
    click_on 'Gravar'

    # Assert
    expect(page).to have_content 'Não foi possível registrar o pedido'
    expect(page).to have_content 'Data Prevista de Entrega não pode ficar em branco'
  end
end