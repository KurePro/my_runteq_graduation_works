class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }

  has_many :foods, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :shopping_items, dependent: :destroy
  has_many :notifications, dependent: :destroy
end
