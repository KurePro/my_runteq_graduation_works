class CreateShoppingItems < ActiveRecord::Migration[8.1]
  def change
    create_table :shopping_items do |t|
      t.string :name, null: false
      t.boolean :is_bought, null: false, default: false
      t.string :memo
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
