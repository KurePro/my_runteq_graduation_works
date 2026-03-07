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
    category_meat = Category.find_by(name: '肉類')
    category_veg  = Category.find_by(name: '野菜')
    category_fish = Category.find_by(name: '魚介類')
    category_milk = Category.find_by(name: '乳製品')
    category_egg  = Category.find_by(name: '卵')
    category_fruit = Category.find_by(name: '果物')
    category_drink = Category.find_by(name: '飲料')
    category_other = Category.find_by(name: 'その他')

    food1 = self.foods.create!(
      name: '豚肉',
      category_id: category_meat&.id,
      expiry_date: Date.yesterday,
      quantity: 200,
      unit: 'g',
      memo: '特売で買った豚肉'
    )

    food2 = self.foods.create!(
      name: 'キャベツ',
      category_id: category_veg&.id,
      expiry_date: Date.today,
      quantity: 1,
      unit: '玉',
    )

    food3 = self.foods.create!(
      name: 'マグロ',
      category_id: category_fish&.id,
      expiry_date: 3.days.from_now,
    )

    food4 = self.foods.create!(
      name: '卵',
      category_id: category_egg&.id,
      expiry_date: 1.week.from_now,
      quantity: 8,
      unit: '個',
    )

    food5 = self.foods.create!(
      name: '牛乳',
      category_id: category_milk&.id,
      expiry_date: 5.days.from_now,
      memo: '朝食用の牛乳'
    )

    food6 = self.foods.create!(
      name: 'リンゴ',
      category_id: category_fruit&.id,
      expiry_date: 1.week.from_now,
      quantity: 4,
    )

    food7 = self.foods.create!(
      name: 'ジュース',
      category_id: category_drink&.id,
      expiry_date: 1.month.from_now,
      memo: 'ご褒美ジュース'
    )

    food8 = self.foods.create!(
      name: 'アイス',
      category_id: category_other&.id,
    )

    food9 = self.foods.create!(
      name: '鶏肉',
      category_id: category_meat&.id,
      expiry_date: 2.days.from_now,
    )

    food10 = self.foods.create!(
      name: 'トマト',
      category_id: category_veg&.id,
      expiry_date: 4.days.from_now,
    )

    food11 = self.foods.create!(
      name: 'サーモン',
      category_id: category_fish&.id,
      expiry_date: 2.days.from_now,
    )

    food12 = self.foods.create!(
      name: 'ヨーグルト',
      category_id: category_milk&.id,
      expiry_date: 1.week.from_now,
    )

    food13 = self.foods.create!(
      name: 'バナナ',
      category_id: category_fruit&.id,
      expiry_date: 5.days.from_now,
    )

    shopping_item1 = self.shopping_items.create!(
      name: '牛乳',
      is_bought: false
    )

    shopping_item2 = self.shopping_items.create!(
      name: 'トマト',
      is_bought: false
    )

    shopping_item3 = self.shopping_items.create!(
      name: 'ヨーグルト',
      is_bought: false
    )

    notification1 = self.notifications.create!(
      food_id: food1.id,
      message: '豚肉の消費期限が過ぎています。',
      checked: false
    )

    notification2 = self.notifications.create!(
      food_id: food2.id,
      message: 'キャベツの消費期限が今日までです。',
      checked: false
    )

    notification3 = self.notifications.create!(
      food_id: food3.id,
      message: 'マグロの消費期限が3日後です。',
      checked: false
    )

    notification4 = self.notifications.create!(
      food_id: food9.id,
      message: '鶏肉の消費期限が3日後です。',
      checked: false
    )

    notification5 = self.notifications.create!(
      food_id: food11.id,
      message: 'サーモンの消費期限が3日後です。',
      checked: false
    )
  end
end
