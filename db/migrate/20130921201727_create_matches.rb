class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :white_id
      t.integer :black_id

      t.timestamps
    end
  end
end
