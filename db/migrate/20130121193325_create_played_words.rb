class CreatePlayedWords < ActiveRecord::Migration
  def change
    create_table :played_words do |t|
      t.integer :game_id
      t.integer :player_id
      t.string :letter
      t.string :word
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end
end
