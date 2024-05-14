class BooksController < ApplicationController
  def index
    @books = Book.all

  def show
    @book = Book.find(params[:id])
  end
end
