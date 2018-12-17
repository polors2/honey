class CreateSales < ActiveRecord::Migration[5.2]
  def change
    create_table :sales do |t|
      t.integer :seller_id
      t.integer :buyer_id
      t.integer :product_id
      t.decimal :price
      t.text :remarks
      t.timestamps
    end
  end
end
