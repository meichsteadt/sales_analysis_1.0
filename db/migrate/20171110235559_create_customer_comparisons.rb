class CreateCustomerComparisons < ActiveRecord::Migration[5.0]
  def change
    create_table :customer_comparisons do |t|
      t.integer :customer_id
      t.integer :customer2_id
      t.string :customer2_name
      t.float :sim_pearson

      t.timestamps
    end
  end
end
