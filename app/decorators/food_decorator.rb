class FoodDecorator < Draper::Decorator
  delegate_all

  def category_name
    object.category&.name || "未分類"
  end

  def display_expiry_date
    object.expiry_date&.strftime("%Y.%m.%d")
  end
end
