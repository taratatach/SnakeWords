class UpdatePlayer < ActiveRecord::Migration
  def up
    add_index :players, :name, :unique => true
  end

  def down
    remove_index :players, :name
  end
end
