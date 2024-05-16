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
    @rental.ownership = @ownership # to be used later in the owner journey
    @rental.user = current_user
    if @rental.save
      redirect_to rentals_path
    else
      @book = @ownership.book
      render 'new', status: :unprocessable_entity
    end
  end

    def update
    @rental = current_user.rentals_as_owner.find(params[:id])
    # raise
    if @rental.update(update_rentals_params)
      redirect_to owner_rentals_path
    else
      render 'index', status: :unprocessable_entity
    end
  end

  private

  def update_rentals_params
    params.require(:rental).permit(:status)
  end

  def rental_params
    params.require(:rental).permit(:start_date, :end_date)
  end
end
