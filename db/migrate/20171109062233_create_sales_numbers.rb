class CreateSalesNumbers < ActiveRecord::Migration[5.0]
  def change
    create_table :sales_numbers do |t|
      t.integer :month
      t.integer :year
      t.float :sales
      t.integer :product_id
      t.integer :customer_id
      t.boolean :rep_number, default: false

      t.timestamps
    end
  end
end
