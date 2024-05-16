class Owner::RentalsController < ApplicationController
  def index
    @rentals = current_user.rentals_as_owner
  end
end
