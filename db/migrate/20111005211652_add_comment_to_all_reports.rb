class AddCommentToAllReports < ActiveRecord::Migration

  def change
    add_column :orders, :comment, :string
    add_column :guaranteereports, :comment, :string
    add_column :postguaranteereports, :comment, :string
  end
end
