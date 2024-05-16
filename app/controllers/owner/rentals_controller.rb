class Owner::RentalsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rentals = current_user.rentals_as_owner
  end
end
