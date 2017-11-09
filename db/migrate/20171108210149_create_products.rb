class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :number, unique: true
      t.integer :position
      t.integer :prev_position

      t.timestamps
    end
  end
end
