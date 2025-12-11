class FoodsController < ApplicationController
  def index
    @foods = Food.all
  end

  private

  def food_params
    params.require(:food).permit(:name, :quantity, :unit, :expiry_date, :memo, :status, :category_id)
  end
end
