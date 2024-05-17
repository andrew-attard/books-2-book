class Rental < ApplicationRecord
  belongs_to :ownership
  belongs_to :user
  has_one :book, through: :ownership

  validates :status, presence: true
  enum status: { pending: 'pending', accepted: 'accepted', rejected: 'rejected' }, _default: :pending
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :start_date_before_end_date

end
