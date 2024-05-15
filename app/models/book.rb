class Book < ApplicationRecord
  has_many :ownerships
  has_many :rentals, through: :ownerships
  has_many :users, through: :ownerships

  validates :title, :author, :genre, :description, :isbn, :cover_url, presence: true
end
