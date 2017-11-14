class AddSalesYtdToProducts < ActiveRecord::Migration[5.0]
  def change
    change_table :products do |t|
      t.float :sales_ytd
    end
  end
end
