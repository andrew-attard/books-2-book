class Rental < ApplicationRecord
  belongs_to :ownership
  # belongs_to :books
  belongs_to :user
  has_one :book, through: :ownership

  validates :status, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
