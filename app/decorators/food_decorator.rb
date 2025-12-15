class FoodDecorator < Draper::Decorator
  delegate_all

  def category_name
    object.category&.name || "未分類"
  end

  def quantity_with_unit
    return nil if object.quantity.blank? || object.unit.blank?
    "#{object.quantity} #{object.unit}"
  end

  def display_expiry_date
    object.expiry_date&.strftime("%Y.%m.%d")
  end
end
