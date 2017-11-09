class CreateCustomersProductsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :customers_products do |t|
      t.integer :product_id
      t.integer :customer_id
      t.float :total_sales

      t.timestamps
    end
  end
end
