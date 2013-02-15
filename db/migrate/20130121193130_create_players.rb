#
# Author : Erwan Guyader
#
class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.integer :totalScore
      t.integer :totalWins

      t.timestamps
    end
  end
end
