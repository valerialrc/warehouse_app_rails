require 'rails_helper'

describe 'Usuário edita um galpão' do
  it 'a partir da página de detalhes' do
    # Arrange
    warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')

    # Act
    visit root_path
    click_on 'Maceio'
    click_on 'Editar'

    # Assert
    expect(page).to have_content('Editar Galpão')
    expect(page).to have_field('Nome', with: 'Maceio')
    expect(page).to have_field('Descrição', with: 'Galpão de Maceio')
    expect(page).to have_field('Código', with: 'MCZ')
    expect(page).to have_field('Endereço', with: 'Rua Três, 2000')
    expect(page).to have_field('Cidade', with: 'Maceio')
    expect(page).to have_field('CEP', with: '33000-001')
    expect(page).to have_field('Área', with: 50_000)
  end

  it 'com sucesso' do
    # Arrange
    warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')

    # Act
    visit root_path
    click_on 'Maceio' 
    click_on 'Editar'
    fill_in 'Nome', with: 'Galpão de Maceió'
    fill_in 'Área', with: 100_000
    fill_in 'Endereço', with: 'Rua Teste, 55'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content('Galpão atualizado com sucesso!')
    expect(page).to have_content('Endereço: Rua Teste, 55')
    expect(page).to have_content('Área: 100000 m2')
    expect(page).to have_content('Nome: Galpão de Maceió')
  end

  it 'e mantem os campos obrigatórios' do
    # Arrange
    warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')

    # Act
    visit root_path
    click_on 'Maceio' 
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Área', with: ''
    fill_in 'Endereço', with: 'Rua Teste, 55'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content('Não foi possível atualizar o galpão')
  end
end