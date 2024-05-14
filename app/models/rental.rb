class Rental < ApplicationRecord
  belongs_to :ownership
  # belongs_to :books
  belongs_to :user

  validates :status, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
