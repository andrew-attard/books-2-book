class SearchController < ApplicationController
  def index
    @query = params[:query]
    @books = Book.where("title LIKE ? OR author LIKE ? OR genre LIKE ? OR isbn LIKE ?", "%#{@query}%", "%#{@query}%", "%#{@query}%", "%#{@query}%")
  end
end
