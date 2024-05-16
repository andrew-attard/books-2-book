class ListItem < ApplicationRecord
  belongs_to :book
  belongs_to :list

  validates :comment, length: { minimum: 6 }, allow_blank: true
  validates :book_id, uniqueness: { scope: :list_id, message: "is already in the list" }
end
