class FoodsController < ApplicationController
  def index
    @foods = current_user.foods.order(expiry_date: :asc)
  end

  def new
    @food = Food.new
    @categories = Category.all
  end

  private

  def food_params
    params.require(:food).permit(:name, :quantity, :unit, :expiry_date, :memo, :status, :category_id)
  end
end
