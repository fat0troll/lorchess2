class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.integer :match_id
      t.integer :move_number
      t.string :move

      t.timestamps
    end
  end
end
