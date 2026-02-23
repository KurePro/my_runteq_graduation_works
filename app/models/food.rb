class Food < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :memo, length: { maximum: 255 }

  belongs_to :user
  belongs_to :category, optional: true
  has_many :notifications, dependent: :destroy

  scope :name_contain, ->(keyword) { where("name LIKE :q OR memo LIKE :q", q: "%#{keyword}%") }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :for_expiry_3_days_notice, -> { where(expiry_date: Date.current + 3.days) }
  scope :for_expiry_day_notice, -> { where(expiry_date: Date.current) }
  scope :for_expired_notice, -> { where("expiry_date < ?", Date.current) }
end
