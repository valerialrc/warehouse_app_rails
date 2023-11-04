class SuppliersController < ApplicationController
  def index
    @suppliers = Supplier.all
  end

  before_action :set_supplier, only: [:show, :edit, :update]
  def show; end

  def new
    @supplier = Supplier.new
  end
  
  def create
    @supplier = Supplier.new(supplier_params)
    
    if @supplier.save()
      redirect_to supplier_path(@supplier.id), notice: 'Fornecedor cadastrado com sucesso!'
    else
      flash.now[:notice] = 'Fornecedor não cadastrado.'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @supplier.update(supplier_params)
      redirect_to supplier_path(@supplier.id), notice: 'Fornecedor atualizado com sucesso!'
    else
      flash[:notice] = 'Não foi possível atualizar o fornecedor'
      render 'edit'
    end
  end

  private

  def supplier_params
    params.require(:supplier).permit(:corporate_name, :brand_name, :registration_number, :full_address,
    :city, :state, :email)
  end

  def set_supplier
    @supplier = Supplier.find(params[:id])
  end

end