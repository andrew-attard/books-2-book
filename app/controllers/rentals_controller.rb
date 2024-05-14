class RentalsController < ApplicationController
  def new
    @ownership = Ownership.find(params[:ownership_id])
    @rental = Rental.new
  end

  def create
    @ownership = Ownership.find(params[:ownership_id])
    @rental = Rental.new(rental_params)
    @rental.list = @rental
    if @rental.save
      redirect_to rental_path(@rental)
    else
      render 'show', status: :unprocessable_entity
    end
  end
end