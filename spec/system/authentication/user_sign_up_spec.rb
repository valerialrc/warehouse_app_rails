require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    # Arrange

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Criar uma conta'
    fill_in 'Nome', with: 'João'
    fill_in 'E-mail', with: 'joao@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'
    
    # Assert
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    within('nav') do
      expect(page).to have_content 'joao@email.com'
      expect(page).to have_button 'Sair'
    end
    user = User.last
    expect(user.name).to eq 'João'
  end
end