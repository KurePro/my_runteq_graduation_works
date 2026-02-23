module FoodsHelper
  def food_card_color(food)
    return 'border-l-default/80' if food.expiry_date.nil? || food.expiry_date > Date.current + 3.days
    return 'border-l-expiry_3_days/80' if food.expiry_date > Date.current && food.expiry_date <= Date.current + 3.days
    return 'border-l-expiry_day/80' if food.expiry_date == Date.current
    'border-l-expired/80'
  end
end
