class ListItemsController < ApplicationController
  before_action :authenticate_user!

  def new
    @list = List.find(params[:list_id])
    @list_item = ListItem.new
    @books = Book.all
  end

  def create
    @book = Book.find(params[:book_id])
    @list = current_user.lists.find_or_create_by(name: 'Wishlist')
    @list_item = @list.list_items.new(book: @book)

    if @list_item.save
      redirect_to book_path(@book), notice: 'Book was added to the Wishlist.'
    else
      redirect_to book_path(@book), alert: "#{@list_item.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @list_item = ListItem.find(params[:id])
    @list = @list_item.list

    if @list.name == "My Rentals" || @list.name == "My Own Books"
      redirect_to list_path(@list), alert: "Cannot remove items directly from '#{@list.name}'."
    else
      @list_item.destroy
      redirect_to list_path(@list), notice: 'Book was removed from the list.', status: :see_other
    end
  end

  private

  def list_item_params
    params.require(:list_item).permit(:list_id, :book_id, :comment)
  end
end
