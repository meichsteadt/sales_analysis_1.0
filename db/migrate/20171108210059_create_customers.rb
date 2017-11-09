class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :state
      t.integer :position
      t.integer :prev_position
      t.string :name_id
      
      t.timestamps
    end
  end
end
