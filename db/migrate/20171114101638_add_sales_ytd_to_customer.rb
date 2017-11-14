class AddSalesYtdToCustomer < ActiveRecord::Migration[5.0]
  def change
    change_table :customers do |t|
      t.float :sales_ytd
    end
  end
end
