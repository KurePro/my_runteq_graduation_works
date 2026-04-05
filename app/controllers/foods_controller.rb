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
        @food.save!
          if @shopping_item_id.present?
            @shopping_item = current_user.shopping_items.find(@shopping_item_id)
            @shopping_item.destroy!
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

  def search_by_barcode
    jan_code = params[:jan_code].to_s.strip

    # バリデーション（JANコードは 8 桁 or 13 桁の数字）
    unless jan_code.match?(/\A\d{8}(\d{5})?\z/)
      render json: { error: "無効なJANコードです" }, status: :unprocessable_entity
      return
    end

    product_name = fetch_product_name_from_yahoo(jan_code)

    if product_name
      render json: { name: product_name }
    else
      render json: { name: nil, message: "商品が見つかりませんでした" }
    end
  end

  private

  def fetch_product_name_from_yahoo(jan_code)
    conn = Faraday.new("https://shopping.yahooapis.jp") do |f|
      f.options.timeout = 5
      f.options.open_timeout = 3
    end

    response = conn.get("/ShoppingWebService/V3/itemSearch", {
      appid:    ENV.fetch("YAHOO_CLIENT_ID"),
      jan_code: jan_code,
      results:  1
    })

    return nil unless response.success?

    data = JSON.parse(response.body)
    hits = data.dig("hits") || []
    return nil if hits.empty?

    raw_name = hits.first.dig("name").to_s
    raw_name.split(/[【\[（(]/)[0].strip.presence

rescue Faraday::Error => e
  Rails.logger.error "Yahoo API Error: #{e.message}"
  nil
end

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
