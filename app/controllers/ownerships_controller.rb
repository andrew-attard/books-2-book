class OwnershipsController < ApplicationController
  def index
    @ownerships = current_user.ownerships.order(created_at: :desc)
    @ownership = Ownership.new
  end

  def show
    @ownership = Ownership.find(params[:id])
  end

  def new
    @book = Book.find(params[:book_id])
    @ownership = Ownership.new
  end

  def create
    @book = Book.find_by(id: ownership_params[:book_id]) || Book.find(params[:book_id])
    if @book.nil?
      flash[:alert] = "Book not found"
      redirect_to ownerships_path and return
    end

    @ownership = @book.ownerships.build(ownership_params)
    @ownership.user = current_user

    if @ownership.save
      add_to_own_books_list(@ownership)
      redirect_to ownerships_path, notice: 'Ownership successfully created and added to My Own Books list.'
    else
      @book = @ownership.book
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @ownership = Ownership.find(params[:id])
    remove_from_own_books_list(@ownership)
    @ownership.destroy
    redirect_to ownerships_path, notice: 'Ownership was successfully deleted.'
  end

  private

  def ownership_params
    params.require(:ownership).permit(:price, :condition, :book_id)
  end

  def add_to_own_books_list(ownership)
    own_books_list = current_user.lists.find_or_create_by(name: 'My Own Books')
    own_books_list.list_items.create(book: ownership.book)
  end

  def remove_from_own_books_list(ownership)
    own_books_list = current_user.lists.find_by(name: 'My Own Books')
    list_item = own_books_list.list_items.find_by(book: ownership.book)
    list_item.destroy if list_item.present?
  end
end
