class Book < ApplicationRecord
  has_many :ownerships
  has_many :rentals, through: :ownerships
  has_many :users, through: :ownerships

end
