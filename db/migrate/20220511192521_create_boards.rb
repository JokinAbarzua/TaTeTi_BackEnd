class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.string :name, unique: true
      t.string :winner
      t.integer :state, default: 0
      t.string :table, default: "n,n,n,n,n,n,n,n,n"
      t.string :nextPlayer
      t.belongs_to :player1
      t.belongs_to :player2
      t.timestamps
    end
  end
end

#j2 = Player.new(full_name: "Peter",alias:"Enky")
#j1 = Player.new(full_name: "jorge",alias:"brujo")