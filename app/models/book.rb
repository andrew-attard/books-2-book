class Book < ApplicationRecord
  has_many :ownerships
  has_many :rentals, through: :ownerships
  has_many :users, through: :ownerships
  has_many :list_items, dependent: :restrict_with_error
  has_many :lists, through: :list_items

  validates :title, :author, :genre, :description, :isbn, :cover_url, presence: true
end
