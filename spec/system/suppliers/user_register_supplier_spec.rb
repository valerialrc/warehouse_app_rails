require 'rails_helper'

describe 'Usuário cadastra um fornecedor' do
  it 'a partir do menu' do
    # Arrange

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar novo fornecedor'

    # Assert
    expect(page).to have_field('Nome Fantasia')
    expect(page).to have_field('Razão Social')
    expect(page).to have_field('CNPJ')
    expect(page).to have_field('Endereço')
    expect(page).to have_field('Cidade')
    expect(page).to have_field('Estado')
    expect(page).to have_field('E-mail')
  end

  it 'com sucesso' do
    # Arrange
  
    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar novo fornecedor'
    fill_in 'Nome Fantasia', with: 'Acme'
    fill_in 'Razão Social', with: 'ACME LTDA'
    fill_in 'CNPJ', with: '111111'
    fill_in 'Endereço', with: 'Avenida do Museu do Amanhã, 1000'
    fill_in 'Cidade', with: 'Rio de Janeiro'
    fill_in 'Estado', with: 'RJ'
    fill_in 'E-mail', with: 'contato@acme.com'
    click_on 'Enviar'
  
    # Assert
    expect(page).to have_content 'Fornecedor cadastrado com sucesso!'
    expect(page).to have_content 'ACME LTDA'
    expect(page).to have_content 'Documento: 111111'
    expect(page).to have_content 'Endereço: Avenida do Museu do Amanhã, 1000 - Rio de Janeiro - RJ'
    expect(page).to have_content 'E-mail: contato@acme.com'
  end

  it 'com dados imcompletos' do
    #    # Arrange
  
    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar novo fornecedor'
    fill_in 'Nome Fantasia', with: ''
    fill_in 'Razão Social', with: ''
    fill_in 'CNPJ', with: ''
    click_on 'Enviar'
  
    # Assert
    expect(page).to have_content 'Fornecedor não cadastrado.'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
  end
end