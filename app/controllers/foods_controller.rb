class FoodsController < ApplicationController
  before_action :set_categories, only: [:index, :new, :create, :edit, :update]

  def index
    @search_form = FoodsSearchForm.new(search_params)
    @foods = @search_form.search(current_user).order(expiry_date: :asc).page(params[:page]).per(12)
  end

  def new
    @food = Food.new

    if params[:shopping_item_id].present?
      @shopping_item = current_user.shopping_items.find(params[:shopping_item_id])
      @food.name = @shopping_item.name
      @food.memo = @shopping_item.memo
      @shopping_item_id = @shopping_item.id
    end
  end

  def create
    @food = current_user.foods.build(food_params)
    @shopping_item_id = params[:shopping_item_id]

    begin
      Food.transaction do
        if @food.save!
          if @shopping_item_id.present?
            @shopping_item = current_user.shopping_items.find(@shopping_item_id)
            @shopping_item.destroy!
          end
        end
      end

      if @shopping_item_id.present?
        flash.now[:notice] = '買い物リストから食材を登録しました。'
        respond_to do |format|
          format.turbo_stream { render :create_from_shopping_item }
          format.html { redirect_to shopping_items_path, notice: '食材を登録しました', status: :see_other }
        end
      else
        respond_to do |format|
          format.html { redirect_to foods_path, notice: '食材を登録しました', status: :see_other }
        end
      end

    rescue ActiveRecord::RecordInvalid => e
      render :new, status: :unprocessable_entity

    rescue StandardError => e
      flash.now[:alert] = '処理中にエラーが発生しました。もう一度お試しください。'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @food = current_user.foods.find(params[:id])
  end

  def update
    @food = current_user.foods.find(params[:id])
    if @food.update(food_params)
      redirect_to foods_path, notice: "食材を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    food = current_user.foods.find(params[:id])
    food.destroy
    redirect_to foods_path, notice: "食材を削除しました。", status: :see_other
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
