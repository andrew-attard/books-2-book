class BooksController < ApplicationController
  def show
    @book = Book.find(params[:id])
    # raise
  end
end
