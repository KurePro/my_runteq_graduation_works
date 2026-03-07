class GuestCleanupJob < ApplicationJob
  queue_as :default

  def perform
    old_users = User.where(name: 'ゲスト').where('created_at < ?', 24.hours.ago)

    old_users&.destroy_all
  end
end
