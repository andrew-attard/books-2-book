class Ownership < ApplicationRecord
  belongs_to :book
  belongs_to :user
  has_many :rentals

  validates :price, presence: true
  validates :condition, presence: true
end
