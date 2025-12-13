class Food < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :memo, presence: true, length: { maximum: 255 }

  belongs_to :user
  belongs_to :category
end
