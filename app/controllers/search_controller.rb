class SearchController < ApplicationController
  def index
    @query = params[:query]
    # @books = Book.where("title ILIKE ? OR author ILIKE ? OR genre ILIKE ? OR isbn LIKE ?", "%#{@query}%", "%#{@query}%", "%#{@query}%", "%#{@query}%")
    @books = Book.search(@query)
  end
end
