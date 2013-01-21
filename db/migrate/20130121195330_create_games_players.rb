class CreateGamesPlayers < ActiveRecord::Migration
  def up
    create_table :games_players do |t|
      t.integer :game_id
      t.integer :player_id
    end
  end

  def down
  end
end