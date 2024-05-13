class Rental < ApplicationRecord
  belongs_to :ownerships
  belongs_to :books
  belongs_to :users

  validates :status, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
