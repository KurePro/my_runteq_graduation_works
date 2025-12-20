class NotificationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    expire_in_3_days_foods = Food.for_expiry_3_days_notice  # foodsモデルのスコープを使用
    expire_in_3_days_foods.find_each do |food| # find_eachで大量データにも対応
      unless Notification.exists?(food_id: food.id, kind: :expiry_3_days)
        Notification.create!(
          user_id: food.user_id,  # userオブジェクト経由ではなく、user_idを直接指定することで効率化
          food_id: food.id,
          kind: :expiry_3_days,
          message: "#{food.name}の賞味期限が3日後です。"
        )
      end
    end

    expire_on_day_foods = Food.for_expiry_day_notice  # 全ユーザーの食材から当日の賞味期限のものを取得することで、データ探しの効率化を図る
    expire_on_day_foods.find_each do |food|
      unless Notification.exists?(food_id: food.id, kind: :expiry_day)
        Notification.create!(
          user_id: food.user_id,
          food_id: food.id,
          kind: :expiry_day,
          message: "#{food.name}の賞味期限が本日です。"
        )
      end
    end

    expired_foods = Food.for_expired_notice
    expired_foods.find_each do |food|
      unless Notification.exists?(food_id: food.id, kind: :expired)
        Notification.create!(
          user_id: food.user_id,
          food_id: food.id,
          kind: :expired,
          message: "#{food.name}の賞味期限が過ぎています。"
        )
      end
    end
  end
end
