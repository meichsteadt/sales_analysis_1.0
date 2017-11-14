class AddSalesLastYearToProduct < ActiveRecord::Migration[5.0]
  def change
    change_table :products do |t|
      t.float :sales_last_year
    end
  end
end
