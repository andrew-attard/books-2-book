class Ownership < ApplicationRecord
  has_many :rentals, dependent: :destroy
  belongs_to :book
  belongs_to :user

  validates :price, presence: true
  validates :condition, presence: true
  validates :book, presence: true

  CONDITIONS = ["Poor", "Fair", "Good", "Excellent", "Mint"]
end
