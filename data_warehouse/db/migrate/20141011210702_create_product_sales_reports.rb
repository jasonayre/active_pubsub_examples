class CreateProductSalesReports < ActiveRecord::Migration
  def change
    create_table :product_sales_reports do |t|
      t.integer :product_id
      t.float :total_sales

      t.timestamps
    end
  end
end
