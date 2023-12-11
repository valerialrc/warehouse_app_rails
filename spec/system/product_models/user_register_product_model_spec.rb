require 'rails_helper'

require 'rails_helper'

describe 'Usuário cadastra um modelo de produtos' do  
  it 'com sucesso' do
    # Arrange
    supplier = Supplier.create!(corporate_name: 'SAMSUNG LTDA',
                                brand_name: 'Samsung', registration_number: '477777',
                                full_address: 'Av. das Nações Unidas, 100',
                                city: 'São Paulo', state: 'SP',
                                email: 'contato@samsung.com')

    other_supplier = Supplier.create!(corporate_name: 'LG LTDA', brand_name: 'LG',
                                      registration_number: '22222222',
                                      full_address: 'Praça das Palmeiras, 110',
                                      city: 'São Paulo', state: 'SP',
                                      email: 'contato@lg.com')

    user = User.create!(email: 'joao@email.com', password: 'password')

    # Act
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end
    click_on 'Cadastrar Novo'
    fill_in 'Nome', with: 'TV 40 polegadas' 
    fill_in 'Peso', with: 10_000
    fill_in 'Altura', with: 60
    fill_in 'Largura', with: 90
    fill_in 'Profundidade', with: 10
    fill_in 'SKU', with: 'TV40-SAMS-XPTO'
    select 'Samsung', from: 'Fornecedor' 
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Modelo de Produto cadastrado com sucesso!'
    expect(page).to have_content 'TV 40 polegadas'
    expect(page).to have_content 'Fornecedor: Samsung'
    expect(page).to have_content 'SKU: TV40-SAMS-XPTO'
    expect(page).to have_content 'Dimensão: 60cm x 90cm x 10cm'
    expect(page).to have_content 'Peso: 10000g'
  end

  it 'deve preencher todos os campos' do
    # Arrange
    supplier = Supplier.create!(corporate_name: 'SAMSUNG LTDA',
                                brand_name: 'Samsung', registration_number: '477777',
                                full_address: 'Av. das Nações Unidas, 100',
                                city: 'São Paulo', state: 'SP',
                                email: 'contato@samsung.com')

    user = User.create!(email: 'joao@email.com', password: 'password')

    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Produtos'
    click_on 'Cadastrar Novo'
    fill_in 'Nome', with: '' 
    fill_in 'SKU', with: ''
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Não foi possível cadastrar o modelo de produto'
    
  end
end