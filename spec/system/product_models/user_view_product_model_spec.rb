require 'rails_helper'

describe 'Usuário vê modelo de produtos' do
  it 'se tiver autenticado' do
    # Arrange

    # Act
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end 

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'a partir do menu' do
    # Arrange
    user = User.create!(email: 'joao@email.com', password: 'password')

    # Act
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end 

    # Assert
    expect(current_path).to eq product_models_path
  end

  it 'com sucesso' do
    # Arrange
    supplier = Supplier.create!(corporate_name: 'SAMSUNG LTDA',
                                brand_name: 'Samsung', registration_number: '477777',
                                full_address: 'Av. das Nações Unidas, 100',
                                city: 'São Paulo', state: 'SP',
                                email: 'contato@samsung.com')

    ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45,
                         depth: 10, sku: 'TV32-SAMSU', supplier: supplier)

    ProductModel.create!(name: 'SoundBar 7.1', weight: 3000, width: 60,
                         height: 15, depth: 60, sku: 'SOUND-SAMSUNG', supplier: supplier)
    
    user = User.create!(email: 'joao@email.com', password: 'password')

    # Act
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end 

    # Assert
    expect(page).to have_content 'TV 32'
    expect(page).to have_content 'TV32-SAMSU'
    expect(page).to have_content 'Samsung'    
    expect(page).to have_content 'SoundBar 7.1'
    expect(page).to have_content 'SOUND-SAMSUNG'
    expect(page).to have_content 'Samsung'
  end

  it 'e não existem produtos cadastrados' do
    # Arrange

    user = User.create!(email: 'joao@email.com', password: 'password')

    # Act
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end 

    # Assert
    expect(page).to have_content 'Nenhum modelo de produto cadastrado.'
  end
end