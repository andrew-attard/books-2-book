class RemoveConditionFromBooks < ActiveRecord::Migration[7.1]
  def change
    remove_column :books, :condition, :string
  end
end
