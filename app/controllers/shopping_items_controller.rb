class ShoppingItemsController < ApplicationController
  def index
    @shopping_items = current_user.shopping_items.where(is_bought: false).order(created_at: :desc).page(params[:page]).per(12)

    @shopping_item = ShoppingItem.new
  end

  def create
    @shopping_item = current_user.shopping_items.build(shopping_item_params)
    if @shopping_item.save

      flash.now[:notice] = "買い物リストに追加しました。"

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to shopping_items_path, notice: "買い物リストに追加しました。" }
      end
    else
      @shopping_items = current_user.shopping_items.order(created_at: :desc).page(params[:page]).per(12)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @shopping_item = current_user.shopping_items.find(params[:id])
    @shopping_item.destroy

    flash.now[:notice] = "買い物リストから削除しました。"

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to shopping_items_path, status: :see_other }
    end
  end

  private

  def shopping_item_params
    params.require(:shopping_item).permit(:name, :memo)
  end
end
