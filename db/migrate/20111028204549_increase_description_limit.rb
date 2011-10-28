class IncreaseDescriptionLimit < ActiveRecord::Migration
  def change
    change_column :orders, :order_description, :string, :limit => 4000
    change_column :guaranteereports, :description, :string, :limit => 4000
    change_column :postguaranteereports, :description, :string, :limit => 4000
  end
end
