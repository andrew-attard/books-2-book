class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :genre
      t.text :description
      t.string :condition
      t.string :isbn
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
