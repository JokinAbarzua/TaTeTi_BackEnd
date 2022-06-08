class Player < ApplicationRecord
    validates :full_name, presence: true, uniqueness: true
    validates :password, presence: true
    validates :token, Uniqueness: true
    before_create :set_token
    before_create :set_victories
    has_many :boards,class_name: "Board" #dependent: :destroy no funciona ya hay 2 belongs to para player1 y 2 por lo que no sabe cual eliminar

   

    def set_token
        self.token = SecureRandom.uuid 
    end

    def set_victories
        self.victories = 0
    end
end
