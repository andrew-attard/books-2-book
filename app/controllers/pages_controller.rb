class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @books = Book.all.select { |book| book.title.split.size <= 3 }
  end
end
