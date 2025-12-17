class ChangeExpiryDateToDate < ActiveRecord::Migration[8.1]
  def change
    change_column :foods, :expiry_date, :date
  end
end
