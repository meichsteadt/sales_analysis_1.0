class AddProductNumberOrders < ActiveRecord::Migration[5.0]
  def change
    change_table :orders do |t|
      t.string :product_number
    end
  end
end
