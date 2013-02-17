#
# Author : Erwan Guyader
#
class UpdateGame < ActiveRecord::Migration
  def up
    add_column :games, :firstWord, :string, { :default => "" }
    add_column :games, :fwX, :integer, { :default => 0 }
    add_column :games, :fwY, :integer, { :default => 0 }
  end

  def down
    remove_column :games, :fwY
    remove_column :games, :fwX
    remove_column :games, :firstWord
  end
end
