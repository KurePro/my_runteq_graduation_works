class ChangeCategoryIdNullOnFoods < ActiveRecord::Migration[8.1]
  def change
    change_column_null :foods, :category_id, true
  end
end
