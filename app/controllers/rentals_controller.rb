class RentalsController < ApplicationController
  def index
    @rentals = current_user.rentals
  end

  def new
    @ownership = Ownership.find(params[:ownership_id])
    @book = @ownership.book
    @rental = Rental.new
  end

  def create
    @ownership = Ownership.find(params[:ownership_id])
    @rental = Rental.new(rental_params)
    @rental.ownership = @ownership
    # @rental.pending! # to be used later in the owner journey
    @rental.status = "false"
    @rental.user = current_user
    if @rental.save
      redirect_to rentals_path
    else
      @book = @ownership.book
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def rental_params
    params.require(:rental).permit(:start_date, :end_date)
  end
end
