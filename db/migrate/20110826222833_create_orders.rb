class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :email
      t.string :producer
      t.string :product_name
      t.string :image1
      t.string :image2
      t.string :image3
      t.string :order_description

      t.timestamps
    end
  end
end
