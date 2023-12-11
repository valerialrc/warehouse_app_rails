require 'rails_helper'

describe "Warehouse API" do
  context 'GET /api/v1/warehouse/1' do
    it 'success' do
      # Arrange
      warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                                  area: 50_000, address: 'Rua Três, 2000',
                                  cep: '33000-001', description: 'Galpão de Maceio')

      # Act
      get "/api/v1/warehouses/#{warehouse.id}"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["name"]).to eq('Maceio')
      expect(json_response.keys).not_to include 'created_at'
      expect(json_response.keys).not_to include 'updated_at'
    end

    it 'fail if warehouse not found' do
      # Arrange

      # Act
      get "/api/v1/warehouses/999999"

      # Assert
      expect(response.status).to eq 404
    end
  end

  context 'GET /api/v1/warehouses' do
    it 'success' do
      # Arrange
      Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio',
                        area: 50_000, address: 'Rua Três, 2000',
                        cep: '33000-001', description: 'Galpão de Maceio')

      Warehouse.create!(name: 'BH', code: 'BHZ',
                        city: 'Belo Horizonte', area: 20_000,
                        address: 'Rua Dois, 55',
                        cep: '35000-777',
                        description: 'Galpão de BH')
        
      # Act
      get "/api/v1/warehouses"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]['name']).to eq 'Maceio'
      expect(json_response[1]['name']).to eq 'BH'
    end

    it 'return empty if there is no warehouse' do
      # Arrange
        
      # Act
      get "/api/v1/warehouses"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it 'fail if theres an internal error' do
      # Arrange
      allow(Warehouse).to receive(:all).and_raise(ActiveRecord::QueryCanceled)
        
      # Act
      get "/api/v1/warehouses"

      # Assert
      expect(response).to have_http_status(500)
    end
  end

  context 'POST /api/v1/warehouses' do
    it 'success' do
      # Arrange
      warehouse_params = { warehouse: {name: 'Galpão de BH', code: 'BHZ',
                           city: 'Belo Horizonte', area: 20_000,
                           address: 'Rua Dois, 55',
                           cep: '35000-777',
                           description: 'Galpão de BH' } }
        
      # Act
      post "/api/v1/warehouses", params: warehouse_params

      # Assert
      expect(response).to have_http_status(201)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq 'Galpão de BH'
      expect(json_response['code']).to eq 'BHZ'
      expect(json_response['city']).to eq 'Belo Horizonte'
      expect(json_response['area']).to eq 20_000
      expect(json_response['address']).to eq 'Rua Dois, 55'
      expect(json_response['cep']).to eq '35000-777'
      expect(json_response['description']).to eq 'Galpão de BH'
    end

    it 'fail if parameters are not complete' do
      # Arrange
      warehouse_params = { warehouse: {name: 'Galpão de BH', code: 'BHZ' } }
        
      # Act
      post "/api/v1/warehouses", params: warehouse_params

      # Assert
      expect(response).to have_http_status(412)
      expect(response.body).not_to include 'Código não pode ficar em branco'
      expect(response.body).to include 'Cidade não pode ficar em branco'
    end

    it 'fail if theres an internal error' do
      # Arrange
      allow(Warehouse).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)

      warehouse_params = { warehouse: {name: 'Galpão de BH', code: 'BHZ',
                           city: 'Belo Horizonte', area: 20_000,
                           address: 'Rua Dois, 55',
                           cep: '35000-777',
                           description: 'Galpão de BH' } }
        
      # Act
      post "/api/v1/warehouses", params: warehouse_params

      # Assert
      expect(response).to have_http_status(500)
    end
  end
end
