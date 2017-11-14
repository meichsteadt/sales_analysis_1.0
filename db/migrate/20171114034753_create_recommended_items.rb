class CreateRecommendedItems < ActiveRecord::Migration[5.0]
  def change
    create_table :recommended_items do |t|
      t.integer :customer_id
      t.integer :product_id
      t.float :projected_sales
      t.string :product_number

      t.timestamps
    end
  end
end
