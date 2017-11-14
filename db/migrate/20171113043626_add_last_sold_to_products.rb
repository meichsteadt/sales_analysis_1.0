class AddLastSoldToProducts < ActiveRecord::Migration[5.0]
  def change
    change_table :products do |t|
      t.date :last_sold
    end
  end
end
