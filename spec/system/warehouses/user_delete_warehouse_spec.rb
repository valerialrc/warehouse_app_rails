require 'rails_helper'

describe 'Usuário remove um galpão' do
  it 'com sucesso' do
    # Arrange
    warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')

    # Act
    visit root_path
    click_on 'Maceio'
    click_on 'Remover'

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Galpão removido com sucesso!')
    expect(page).not_to have_content('Código: MCZ')
    expect(page).not_to have_content('50000 m2')
    expect(page).not_to have_content('Cidade: Maceio')
  end

  it 'e não remove outros galpões' do
    # Arrange
    first_warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ',
                                       city: 'Maceio', area: 50_000,
                                       address: 'Rua Três, 2000',
                                       cep: '33000-001',
                                       description: 'Galpão de Maceio')

    second_warehouse = Warehouse.create!(name: 'BH', code: 'BHZ',
                                       city: 'Belo Horizonte', area: 20_000,
                                       address: 'Rua Dois, 55',
                                       cep: '35000-777',
                                       description: 'Galpão de BH')

    # Act
    visit root_path
    click_on 'Maceio'
    click_on 'Remover'

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Galpão removido com sucesso!')
    expect(page).not_to have_content('Maceio')
    expect(page).to have_content('Belo Horizonte')

  end
end