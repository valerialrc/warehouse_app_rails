require 'rails_helper'

describe 'Usuário vê fornecedores' do
  it 'a partir do menu' do
    # Arrange

    # Act
    visit root_path
    within('nav') do
      click_on 'Fornecedores'
    end

    # Assert
    expect(current_path).to eq suppliers_path
  end

  it 'com sucesso' do
    # Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                     registration_number: '433332323',
                     full_address: 'Av. das Palmas, 100', city: 'Bauru',
                     state: 'SP', email: 'contato@acme.com')

    Supplier.create!(corporate_name: 'Spark LTDA', brand_name: 'Spark',
                     registration_number: '55656555',
                     full_address: 'Torre da Industria, 1', city: 'Teresina',
                     state: 'PI', email: 'contato@spark.com')

    # Act
    visit root_path
    within('nav') do
      click_on 'Fornecedores'
    end
    
    # Assert
    expect(page).to have_content ('Fornecedores')
    expect(page).to have_content ('ACME')
    expect(page).to have_content ('Bauru - SP')
    expect(page).to have_content ('Spark')
    expect(page).to have_content ('Teresina - PI')
  end
end