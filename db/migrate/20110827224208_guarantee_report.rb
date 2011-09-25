class GuaranteeReport < ActiveRecord::Migration
  def change
    create_table :guaranteereports do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :producer
      t.string :purchase_date
      t.string :purchase_place
      t.string :purchase_id
      t.string :purchase_guarantee_id
      t.string :type
      t.string :pin
      t.string :description

      t.timestamps
    end
  end
end
