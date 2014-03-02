class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :steam_id
      t.datetime "synchronized_at"

      t.timestamps
    end

    add_index :players, :steam_id, :unique => true
  end
end
