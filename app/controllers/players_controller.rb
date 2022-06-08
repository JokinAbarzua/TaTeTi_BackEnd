class PlayersController < ApplicationController    
    before_action :set_player_byId, only:[:showById,:destroy]
    before_action :check_token, only:[:destroy]
    before_action :set_player, only:[:login]

    def create 
        @player = Player.new(player_params)
        player_save
    end

    def index
        @players = Player.all 
        render json:{status: 200,players: @players} 
    end

    def destroy
        if (@player.destroy)
            render json:{status:200, message: "Borrado con exito"}
        else
            render json:{status:400, message: @board.errors.details}
        end
    end

    def login
        render json:{status:200,player: @player}
    end

    def showById
        render json:{status:200,player: @player}
    end

    private

    def player_params        
        params.require(:player).permit(:full_name,:alias,:password,:id)
    end

    def player_save
        if @player.save
            render json:{stauts: 200,player: @player}
        else
            render json:{status:400,message: @player.errors.details}
        end
    end

    def set_player
        @player = Player.find_by(full_name: params[:full_name],password: params[:password])
        return if (@player.present?)
            render json:{status:400,message:"no se escontro el juador"}
            false
    end
    
    def set_player_byId
        @player = Player.find_by(id:params[:id])
        return if (@player.present?)
            render json:{status:400,message:"no se escontro el juador"}
            false
    end

    def check_token
        return if request.headers["Authorization"] == @player.token

        render status: 401, json:{message:"No coincide el token"}#401 significa no autorizado
        false    
    end
end

