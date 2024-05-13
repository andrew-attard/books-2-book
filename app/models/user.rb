class User < ApplicationRecord
  has_many :rentals
  has_many :ownerships
  has_many :books, through: :ownerships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true
end
