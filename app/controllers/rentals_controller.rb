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
      add_to_rentals_list(@rental)
      redirect_to rentals_path, notice: 'Rental successfully created and added to My Rentals list.'
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

  def add_to_rentals_list(rental)
    rentals_list = current_user.lists.find_or_create_by(name: 'My Rentals')
    rentals_list.list_items.create(book: rental.ownership.book)
  end
end
