class AddPassColumnToGame < ActiveRecord::Migration
  def up
    add_column :games, :pass, :boolean, :default => false
  end

  def down
    remove_column :games, :pass
  end
end
