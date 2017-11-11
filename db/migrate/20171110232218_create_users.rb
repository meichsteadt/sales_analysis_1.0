class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.float :sales_ytd
      t.float :prev_sales_ytd
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
