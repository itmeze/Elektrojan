class ChangeTyeColumnName < ActiveRecord::Migration
  def change
    rename_column :postguaranteereports, :type, :rodzaj
  end
end
