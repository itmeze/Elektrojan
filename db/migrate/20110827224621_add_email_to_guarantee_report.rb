class AddEmailToGuaranteeReport < ActiveRecord::Migration
  def change
    add_column :guaranteereports, :email, :string
  end
end
