class ShoppingItem < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :memo, length: { maximum: 255 }

  belongs_to :user
end
