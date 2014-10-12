class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :product_id
      t.integer :customer_id
      t.float :price

      t.timestamps
    end
  end
end
