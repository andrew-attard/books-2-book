class AddColumnsToOwnerships < ActiveRecord::Migration[7.1]
  def change
    add_column :ownerships, :price, :integer
    add_column :ownerships, :condition, :string
  end
end
