class FoodsController < ApplicationController
  before_action :set_categories, only: [:new, :create, :edit, :update]

  def index
    @foods = current_user.foods.order(expiry_date: :asc)
  end

  def new
    @food = Food.new
  end

  def create
    @food = current_user.foods.build(food_params)
    if @food.save
      redirect_to foods_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def food_params
    params.require(:food).permit(:name, :quantity, :unit, :expiry_date, :memo, :status, :category_id)
  end

  def set_categories
    @categories = Category.all
  end
end
