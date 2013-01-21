class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :size
      t.string :dictionary
      t.boolean :finished

      t.timestamps
    end
  end
end
