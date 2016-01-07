require "yaml"
require_relative "./chess/version"
require_relative "./chess/pieces"
require_relative "./chess/board_characters"
require_relative "./chess/game_engine"
module Chess
  # Your code goes here...
  class Chess
    attr_reader :turn_num, :white_player, :black_player
    def initialize
      print "Would you like to play from a saved game? (Y/N) "
      answer = gets.chomp
      if /[Yy]([Ee][Ss])?/ ~  answer
        load_game()
      else
        @board = Board.new
        player_names = setup()
        @white_player = player_names.first
        @black_player = player_names.last
        @turn_num = 0
        @game = GameEngine.new(@game, @white_player, @black_player)
      end
    end

    def play
      game_is_over = game_over?
      until game_is_over
        print "Would you like to save the game? (Y/N) "
	save? = gets.chomp
	if save?
          save_game
	end
        game_loop() #modifies program state
	@turn_num = @turn_num + 1
	game_is_over = game_over?
      end
      winner = game_is_over
      return winner
    end
    private 
    def game_loop
     puts @game.to_s
     puts "It is turn."
     move = receive_move()
     is_valid = @game.is_valid?(move)
     until is_valid
       move = receive_move()
       is_valid = @game.is_valid?(move)
     end
     @game.make_move(move)
     "Player # 

    end
    def setup
      puts "Welcome to Chess!"
      print "Who will be first (white)? "
      p1 = gets.chomp
      print "Welcome, #{p1}. Who will be black? "
      p2 = gets.chomp
      puts "STARTING GAME"
      return [p1, p2]
    end

    game_over?
      @game.game_over?
    end

    def current_player
      turn_num.even? ? @white_player : @black_player
    end

    def save_game
      puts "Please enter a filename to save."
      filename = gets.chomp
      puts "Would you like to quit? (Y/N)"
      quit? = gets.chomp      
      if quit?
        puts "Thanks for playing!"
	exit!
      end
    end
    def load_game
      puts "Give a filename."

    end
  end

end

chess = Chess.new
chess.play
