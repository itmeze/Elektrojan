class ChangeTypeColumnName < ActiveRecord::Migration
  def change
    rename_column :guaranteereports, :type, :rodzaj

  end
end
