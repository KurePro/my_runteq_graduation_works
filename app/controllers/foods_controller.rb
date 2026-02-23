class FoodsController < ApplicationController
  before_action :set_categories, only: [:index, :new, :create, :edit, :update]

  def index
    @search_form = FoodsSearchForm.new(search_params)
    @foods = @search_form.search(current_user).order(expiry_date: :asc).page(params[:page]).per(12)
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

  def edit
    @food = current_user.foods.find(params[:id])
  end

  def update
    @food = current_user.foods.find(params[:id])
    if @food.update(food_params)
      redirect_to foods_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    food = current_user.foods.find(params[:id])
    food.destroy
    redirect_to foods_path, status: :see_other
  end

  private

  def food_params
    params.require(:food).permit(:name, :quantity, :unit, :expiry_date, :memo, :status, :category_id)
  end

  def set_categories
    @categories = Category.all
  end

  def search_params
    params.fetch(:foods_search_form, {}).permit(:search_keyword, :category_id, :expiry_status)
  end
end
