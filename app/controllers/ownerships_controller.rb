class OwnershipsController < ApplicationController
  def index
    @ownerships = Ownership.all
  end

  def show
    @ownership = Ownership.find(params[:id])
  end

  def new
    @ownership = Ownership.new
  end

  def create
    @ownership = Ownership.new(ownership_params)
    if @ownership.save
      redirect_to ownership_path(@ownership)
    else
      render 'new', status: unprocessable_entity
    end
  end

  private
  def ownership_params
    params.require(:ownership).permit(:price, :condition, :book)
  end
end
