class List < ApplicationRecord
  belongs_to :user
  has_many :list_items, dependent: :destroy
  has_many :books, through: :list_items

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
