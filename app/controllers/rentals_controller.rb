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
    @rental.status = "false"
    @rental.user = current_user

    if @rental.save
      add_to_rentals_list(@rental)
      redirect_to rentals_path, notice: 'Rental successfully created and added to My Rentals list.'
    else
      @book = @ownership.book
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def rental_params
    params.require(:rental).permit(:start_date, :end_date)
  end

  def add_to_rentals_list(rental)
    rentals_list = current_user.lists.find_or_create_by(name: 'My Rentals')
    rentals_list.list_items.create(book: rental.ownership.book)
  end
end
