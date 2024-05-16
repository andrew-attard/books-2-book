class OwnershipsController < ApplicationController
  # Note that I was initially having issues with creating a new ownership as there
  # was no @ownership instance initialized from the index action. It was necessary
  # to add @ownership = Ownership.new here
  def index
    @ownerships = Ownership.all
    @ownership = Ownership.new
  end

  def show
    @ownership = Ownership.find(params[:id])
  end

  def new
    @ownership = Ownership.new
  end

  def create
    @user = current_user
    @ownership = Ownership.new(ownership_params)
    @ownership.user = @user
    if @ownership.save
      redirect_to ownership_path(@ownership)
    else
      render :index, status: unprocessable_entity
    end
  end

  private

  def ownership_params
    params.require(:ownership).permit(:price, :condition, :book_id, :user_id)
  end
end
