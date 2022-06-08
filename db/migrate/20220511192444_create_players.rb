class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :full_name, Unique: true
      t.string :alias
      t.string :password
      t.integer :victories 
      t.string :token      
      t.timestamps
    end
  end
end
