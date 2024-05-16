class User < ApplicationRecord
  has_many :rentals
  has_many :ownerships
  has_many :books, through: :ownerships
  has_many :lists, dependent: :destroy
  has_many :list_items, through: :lists

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true

  after_create :create_default_wishlist

  private

  def create_default_wishlist
    lists.create(name: 'Wishlist')
  end
end
