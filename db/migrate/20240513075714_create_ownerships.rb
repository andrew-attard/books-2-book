class CreateOwnerships < ActiveRecord::Migration[7.1]
  def change
    create_table :ownerships do |t|
      t.references :book, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
