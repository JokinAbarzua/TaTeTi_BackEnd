class Board < ApplicationRecord
    validates :name, presence: true, uniqueness: true 
    belongs_to :player1, class_name: "Player"
    belongs_to :player2, class_name: "Player",optional: true

    enum state: {waiting: 0, started: 1, finished: 2}
end
