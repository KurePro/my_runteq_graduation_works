# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
[
  { name: '肉類' },
  { name: '野菜' },
  { name: '魚介類' },
  { name: '乳製品' },
  { name: '卵' },
  { name: '果物' },
  { name: '飲料' },
  { name: '調味料' },
  { name: '加工食品' },
  { name: 'その他' }
].each do |category_data|
  Category.find_or_create_by!(name: category_data[:name])
end
