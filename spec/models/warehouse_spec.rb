require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        # Arrange
        warehouse = Warehouse.new(name: '', code: 'RIO', address: 'Rua Dois, 100',
                                  cep: '25000-555', city: 'Rio de Janeiro',
                                  area: 10000, description: 'Galpão do Rio')
  
        # Act
        result = warehouse.valid?
  
        # Assert
        expect(result).to eq false
      end
  
      it 'false when code is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: '', address: 'Rua Dois, 100',
                                  cep: '25000-555', city: 'Rio de Janeiro',
                                  area: 10000, description: 'Galpão do Rio')
  
        # Act
        result = warehouse.valid?
  
        # Assert
        expect(result).to eq false
      end
  
      it 'false when address is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: '',
                                  cep: '25000-555', city: 'Rio de Janeiro',
                                  area: 10000, description: 'Galpão do Rio')
  
        # Act
        result = warehouse.valid?
  
        # Assert
        expect(result).to eq false
      end
  
      it 'false when cep is empty' do
        # Arrange
        warehouse = Warehouse.new(name: '', code: 'RIO', address: 'Rua Dois, 100',
                                  cep: '', city: 'Rio de Janeiro',
                                  area: 10000, description: 'Galpão do Rio')
  
        # Act
        result = warehouse.valid?
  
        # Assert
        expect(result).to eq false
      end
  
      it 'false when city is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Rua Dois, 100',
                                  cep: '25000-555', city: '',
                                  area: 10000, description: 'Galpão do Rio')
  
        # Act
        result = warehouse.valid?
  
        # Assert
        expect(result).to eq false
      end
  
      it 'false when area is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Rua Dois, 100',
                                  cep: '25000-555', city: 'Rio de Janeiro',
                                  area: nil, description: 'Galpão do Rio')
  
        # Act
        result = warehouse.valid?
  
        # Assert
        expect(result).to eq false
      end
  
      it 'false when description is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Rua Dois, 100',
                                  cep: '25000-555', city: 'Rio de Janeiro',
                                  area: 10000, description: '')
  
        # Act
        result = warehouse.valid?
  
        # Assert
        expect(result).to eq false
      end
    end

    it 'false when code is already in use' do
      # Arrange
      first_warehouse = Warehouse.create(name: 'Rio', code: 'RIO',
                                        address: 'Rua Dois, 100', cep: '25000-555',
                                        city: 'Rio de Janeiro', area: 10000,
                                        description: 'Galpão do Rio')
      
      second_warehouse = Warehouse.new(name: 'Niterói', code: 'RIO',
                                      address: 'Rua Um, 100', cep: '25000-444',
                                      city: 'Niterói', area: 20000,
                                      description: 'Galpão de Niterói')
    
      # Act
      result = second_warehouse.valid?

      # Assert
      expect(result).to eq false
    end
  end

  describe '#full_description' do
    it 'exibe o nome e o código' do
      # Arrange  
      w = Warehouse.new(name: 'Galpão Cuibá', code: 'CBA')
      
      # Act
      result = w.full_description

      # Assert
      expect(result).to eq('CBA | Galpão Cuibá')
    end
  end
end
