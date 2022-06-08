class BoardsController < ApplicationController   
    before_action :set_board, only:[:join]
    before_action :set_board_byId, only:[:move,:show,:destroy]
    before_action :set_player, only:[:create,:join,:move,:destroy]
    before_action :check_token, only:[:create,:join,:move,:destroy]
    after_action :check_winner, only:[:move]


    def create 
        @board = Board.new(name:params[:name],nextPlayer:@player.full_name,player1:@player)
        board_save
    end

    def index
        @boards = Board.all
        render json:{status:200,boards: @boards} 
    end

    def show
        if(@board.player2 == nil)
            render json:{status:200, board:@board,player1_name:@board.player1.full_name,player2_name:""}
        else
            render json:{status:200, board:@board,player1_name:@board.player1.full_name,player2_name:@board.player2.full_name}
        end
    end

    def destroy 
        if(@player == @board.player1)
            if (@board.destroy)
                render json:{status:200, message: "Borrado con exito"}
            else
                render json:{status:400, message: @board.errors.details}
            end
        else
            render json:{status:401, message: "No tiene permiso para eliminar la partida"}
        end
    end

    def join        
        if(@board.waiting?)
            @board.player2 = @player
            @board.state = 1
            board_save
        else
            render json:{status:210,message: "El juego ya esta iniciado"} #210 significa que el jueego ya esta iniciado (ya hay player 2)
        end
    end

    def move
        if(@board.started?)                        
            if(@board.nextPlayer == @player.full_name && params[:table] != nil)                
                tabBack = @board.table.split(',')    #separo los string ya que entre cliente servidor se envia el tablero como string
                tabla = params[:table]                
                tabFront = params[:table].try(:split, ",") || tabBack
                for i in (0..8)
                    if ( (tabBack[i] != tabFront[i]) && tabBack[i]!= 'n' )
                        render json:{status:210,message: "La casilla ya esta marcada"} #el 210 es que jugo sobre una casilla ya marcada
                        return
                    end
                end
                @board.table = tabla
                change_nextPlayer
                board_save            
            else
                render json:{status:211,message: "no es su turno"} #el 211 es que el que jugo no era su turno  
                return              
            end
        else
            render json:{status:212,message: "El juego no a comenzado aun, esperando al jugador 2"} #el 212 es que falta el jugador 2 para empezar
            return
        end
    end

    private

    def set_board
        @board = Board.find_by(name:params[:name])
        return if @board.present?

        render  json:{status: 404,message: "Juego no encontrado"}
        false
    end

    def set_board_byId
        @board = Board.find_by(id:params[:id])
        return if @board.present?

        render  json:{status: 404,message: "Juego no encontrado"}
        false
    end

    def set_player
        @player = Player.find_by(id: params[:player_id])
        return if @player.present?

        render  json:{status: 404,message: "Jugador no encontrado"} 
        false
    end

    def board_params
        params.require(:board).permit(:name,:id,:player_id,:table)
    end

    def board_save
        if @board.save
            render json:{status:200, board: @board}
        else
            render json:{status:400, message: @board.errors.details}
        end
    end

    def check_winner
        tablero = @board.table.split(',')
        if( (tablero[0] == 'x' && tablero[1] == 'x' && tablero[2] == 'x') ||
            (tablero[3] == 'x' && tablero[4] == 'x' && tablero[5] == 'x') ||
            (tablero[6] == 'x' && tablero[7] == 'x' && tablero[8] == 'x') ||
            (tablero[0] == 'x' && tablero[3] == 'x' && tablero[6] == 'x') ||
            (tablero[1] == 'x' && tablero[4] == 'x' && tablero[7] == 'x') ||
            (tablero[2] == 'x' && tablero[5] == 'x' && tablero[8] == 'x') ||
            (tablero[0] == 'x' && tablero[4] == 'x' && tablero[8] == 'x') ||
            (tablero[2] == 'x' && tablero[4] == 'x' && tablero[6] == 'x')
        )
            @board.winner = @board.player1.full_name
            @board.state = 2
            @board.player1.victories = @board.player1.victories + 1
            @board.save
            return
        end
        if( (tablero[0] == 'o' && tablero[1] == 'o' && tablero[2] == 'o') ||
            (tablero[3] == 'o' && tablero[4] == 'o' && tablero[5] == 'o') ||
            (tablero[6] == 'o' && tablero[7] == 'o' && tablero[8] == 'o') ||
            (tablero[0] == 'o' && tablero[3] == 'o' && tablero[6] == 'o') ||
            (tablero[1] == 'o' && tablero[4] == 'o' && tablero[7] == 'o') ||
            (tablero[2] == 'o' && tablero[5] == 'o' && tablero[8] == 'o') ||
            (tablero[0] == 'o' && tablero[4] == 'o' && tablero[8] == 'o') ||
            (tablero[2] == 'o' && tablero[4] == 'o' && tablero[6] == 'o')
        )
            @board.winner = @board.player2.full_name
            @board.state = 2
            @board.player2.victories = @board.player2.victories + 1
            @board.save
            return
        end        
        for i in (0..8)
            if ( tablero[i] == 'n' )                
                return
            end
        end
        @board.state = 2 
        @board.save           
    end

    def change_nextPlayer
        if (@board.player1.full_name == @player.full_name)
            @board.nextPlayer = @board.player2.full_name
        else
            @board.nextPlayer = @board.player1.full_name
        end
    end

    def check_token
        return if request.headers["Authorization"] == @player.token

        render status: 401, json:{message:"No coincide el token"}#401 significa no autorizado
        false    
    end
    

end