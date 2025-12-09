class CreateFoods < ActiveRecord::Migration[8.1]
  def change
    create_table :foods do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.datetime :expiry_date
      t.integer :quantity
      t.string :unit
      t.integer :status
      t.string :memo

      t.timestamps
    end
  end
end
