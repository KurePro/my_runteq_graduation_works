class Notification < ApplicationRecord
  validates :message, presence: true, length: { maximum: 255 }
  validates :kind, presence: true

  belongs_to :user
  belongs_to :food

  enum kind: { expiry_3_days: 0, expiry_day: 1, expired: 2 }
end
