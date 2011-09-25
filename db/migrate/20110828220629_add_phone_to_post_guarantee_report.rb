class AddPhoneToPostGuaranteeReport < ActiveRecord::Migration
  def change
    add_column :postguaranteereports, :phone, :string
  end
end
