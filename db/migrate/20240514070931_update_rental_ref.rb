class UpdateRentalRef < ActiveRecord::Migration[7.1]
  def change
    remove_reference :rentals, :book, foreign_key: true
    add_reference :rentals, :ownership, foreign_key: true
  end
end
