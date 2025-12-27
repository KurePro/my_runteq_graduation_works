class ChangeUserIdNullableInCategories < ActiveRecord::Migration[8.1]
  def change
    change_column_null :categories, :user_id, true
  end
end
