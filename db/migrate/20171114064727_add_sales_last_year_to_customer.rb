class AddSalesLastYearToCustomer < ActiveRecord::Migration[5.0]
  def change
    change_table :customers do |t|
      t.float :sales_last_year
    end
  end
end
