class User < ApplicationRecord
  SAMPLE_CATEGORY_NAMES = %w[肉類 野菜 魚介類 乳製品 卵 果物 飲料 その他].freeze
  SAMPLE_FOOD_TEMPLATES = [
    { name: '豚肉', category_name: '肉類', unit: 'g' },
    { name: '鶏肉', category_name: '肉類', unit: 'g' },
    { name: 'キャベツ', category_name: '野菜', unit: '玉' },
    { name: 'トマト', category_name: '野菜', unit: '個' },
    { name: 'マグロ', category_name: '魚介類', unit: '柵' },
    { name: 'サーモン', category_name: '魚介類', unit: 'パック' },
    { name: '牛乳', category_name: '乳製品', unit: '本' },
    { name: 'ヨーグルト', category_name: '乳製品', unit: '個' },
    { name: '卵', category_name: '卵', unit: '個' },
    { name: 'リンゴ', category_name: '果物', unit: '個' },
    { name: 'バナナ', category_name: '果物', unit: '本' },
    { name: 'ジュース', category_name: '飲料', unit: '本' },
    { name: 'アイス', category_name: 'その他', unit: '個' }
  ].freeze

  SAMPLE_SHOPPING_ITEMS = ['牛乳', 'トマト', 'ヨーグルト'].freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }

  has_many :foods, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :shopping_items, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def self.create_guest!
    random_email = "guest_#{SecureRandom.hex(4)}@example.com"

    guest_user = create!(
      email: random_email,
      password: SecureRandom.urlsafe_base64,
      name: "ゲスト"
    )

    guest_user.setup_sample_data!

    guest_user
  end

  def setup_sample_data!
    now = Time.current
    categories = sample_categories

    Food.insert_all(build_foods_data(categories, now))
    ShoppingItem.insert_all(build_shopping_items_data(now))

    notifications_data = build_notifications_data(now)
    Notification.insert_all(notifications_data) if notifications_data.present?
  end

  private

  def sample_categories
    Category.where(name: SAMPLE_CATEGORY_NAMES).index_by(&:name)
  end

  def build_foods_data(categories, now)
    100.times.map do
      template = SAMPLE_FOOD_TEMPLATES.sample
      category = categories[template[:category_name]]
      has_expiry = rand < 0.8
      has_detail = rand < 0.5
      expiry_date = has_expiry ? rand(-3..14).days.from_now(now).to_date : nil

      {
        user_id: id,
        name: template[:name],
        category_id: category&.id,
        expiry_date: expiry_date,
        quantity: has_detail ? rand(1..5) * 1 : nil,
        unit: has_detail ? template[:unit] : nil,
        memo: has_detail ? "サンプルのメモ（#{template[:name]}）" : nil,
        created_at: now,
        updated_at: now
      }
    end
  end

  def build_shopping_items_data(now)
    SAMPLE_SHOPPING_ITEMS.map do |name|
      { user_id: id, name: name, is_bought: false, created_at: now, updated_at: now }
    end
  end

  def build_notifications_data(now)
    target_foods = foods.where('expiry_date <= ?', 3.days.from_now.to_date).limit(10)

    target_foods.map do |food|
      {
        user_id: id,
        food_id: food.id,
        message: notification_message_for(food),
        checked: false,
        created_at: now,
        updated_at: now
      }
    end
  end

  def notification_message_for(food)
    return "#{food.name}の消費期限が過ぎています。" if food.expiry_date < Date.current
    return "#{food.name}の消費期限が今日までです。" if food.expiry_date == Date.current

    "#{food.name}の消費期限が#{(food.expiry_date - Date.current).to_i}日後です。"
  end
end
