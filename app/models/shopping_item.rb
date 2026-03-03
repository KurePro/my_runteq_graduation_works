class ShoppingItem < ApplicationRecord
  belongs_to :user, presence: true

  validates :name, presence: true
end
