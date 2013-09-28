class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :time
      t.integer :fischer
      t.timestamp :start
      t.string :white
      t.string :black
      t.string :fen
      t.timestamp :last_move

      t.timestamps
    end
  end
end
