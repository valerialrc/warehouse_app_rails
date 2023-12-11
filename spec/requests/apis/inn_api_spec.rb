context 'POST /api/v1/inns' do
  it 'success' do
    # Arrange

    joao = User.create!(email: 'joao@email.com', password: 'password')

    pm = PaymentMethod.create!(name: 'Pix')

    inn_params = {
      inn: {
        user_id: joao.id,
        trade_name: 'Pousada das Pedras',
        legal_name: 'Pousada das Pedras LTDA',
        cnpj: '123456789',
        phone: '(31)99999-9999',
        email: 'contato@pedras.com',
        description: 'Pousada para a família',
        payment_method_id: pm.id,
        accepts_pets: true,
        checkin_time: '13:00',
        checkout_time: '11:00',
        policies: 'Boa convivência',
        active: true,
        address_attributes: {
          street: 'Rua das Pedras',
          number: 56,
          district: 'Centro',
          city: 'BH',
          state: 'MG',
          cep: '30000-000'
        }
      }
    }

    # Act
    post "/api/v1/inns", params: inn_params

    # Assert
    expect(response).to have_http_status(201)
    expect(response.content_type).to include 'application/json'
    json_response = JSON.parse(response.body)
    expect(json_response['user_id']).to eq 1
    expect(json_response['trade_name']).to eq 'Pousada das Pedras'
    expect(json_response['legal_name']).to eq 'Pousada das Pedras LTDA'
    expect(json_response['cnpj']).to eq '123456789'
    expect(json_response['payment_method_id']).to eq 1
    expect(json_response['address']['street']).to eq 'Rua das Pedras'
  end

  it 'fail if parameters are not complete' do
    # Arrange
    inn_params = { inn: {trade_name: 'Pousada das Pedras', legal_code: 'Pousada das Pedras LTDA' } }
      
    # Act
    post "/api/v1/inns", params: inn_params

    # Assert
    expect(response).to have_http_status(412)
    expect(response.body).not_to include 'Nome Fantasia não pode ficar em branco'
    expect(response.body).to include 'Cidade não pode ficar em branco'
    expect(response.body).to include 'Descrição não pode ficar em branco'
  end

  it 'fail if theres an internal error' do
    # Arrange
    allow(Inn).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)

    joao = User.create!(email: 'joao@email.com', password: 'password')

    pm = PaymentMethod.create!(name: 'Pix')

    inn_params = {
      inn: {
        user_id: joao.id,
        trade_name: 'Pousada das Pedras',
        legal_name: 'Pousada das Pedras LTDA',
        cnpj: '123456789',
        phone: '(31)99999-9999',
        email: 'contato@pedras.com',
        description: 'Pousada para a família',
        payment_method_id: pm.id,
        accepts_pets: true,
        checkin_time: '13:00',
        checkout_time: '11:00',
        policies: 'Boa convivência',
        active: true,
        address_attributes: {
          street: 'Rua das Pedras',
          number: 56,
          district: 'Centro',
          city: 'BH',
          state: 'MG',
          cep: '30000-000'
        }
      }
    }
      
    # Act
    post "/api/v1/inns", params: inn_params

    # Assert
    expect(response).to have_http_status(500)
  end
end