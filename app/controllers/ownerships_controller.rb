class OwnershipsController < ApplicationController
  def new
    @book = Book.find(params[:book_id])
    @ownership = Ownership.new
  end

  def create
    @book = Book.find(params[:book_id])
    @ownership = @book.ownerships.build(ownership_params)
    @ownership.user = current_user

    if @ownership.save
      redirect_to book_path(@book), notice: "Ownership claimed successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def ownership_params
    params.require(:ownership).permit(:price, :condition)
  end
end
