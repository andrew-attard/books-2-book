class OwnershipsController < ApplicationController

  def new
    @book = Book.find(params[:book_id])
    @ownership = Ownership.new
  def index
    @ownerships = Ownership.all
  end

  def show
    @ownership = Ownership.find(params[:id])
  end

  def create
    @book = Book.find(params[:book_id])
    @ownership = @book.ownerships.build(ownership_params)
    @ownership.user = current_user

    if @ownership.save
      redirect_to book_path(@book), notice: "Ownership claimed successfully."
    else
      render :new, status: :unprocessable_entity
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
