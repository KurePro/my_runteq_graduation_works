class Notification < ApplicationRecord
  validates :message, presence: true, length: { maximum: 255 }
  validates :kind, presence: true

  belongs_to :user
  belongs_to :food

  enum :kind, { expiry_3_days: 0, expiry_day: 1, expired: 2 }
  # "enum kind:"だとRenderデプロイ時にエラーになるため、enumの書き方をRails8の推奨に合わせています
end
