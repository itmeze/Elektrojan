class PostGuaranteeReport < ActiveRecord::Migration
  def change
    create_table :postguaranteereports do |t|
      t.string :name
      t.string :address
      t.string :email
      t.string :producer
      t.string :type
      t.string :description
      t.string :image1
      t.string :image2
      t.string :image3

      t.timestamps
    end
  end
end
