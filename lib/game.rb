# game.rb
require "yaml"
require_relative "./chess/pieces.rb"
require_relative "./chess/board.rb"
require_relative "./chess/board_characters.rb"  
require_relative "./chess/game_engine.rb"  
require_relative "./game.rb"


module Chess
  # Your code goes here...
  class Game
    attr_reader :turn_num, :white_player, :black_player
    def initialize
      print "Would you like to play from a saved game? (Y/N) "
      answer = gets.chomp
      if /[Yy]([Ee][Ss])?/ =~  answer
        load_game()
      else
        init()
      end
    end

    def play
      game_is_over = game_over?
      until game_is_over
        print "Would you like to save the game? (Y/N) "
      	save = gets.chomp
	      if /[Yy]([Ee][Ss])?/ =~  save
          save_game()
	      end
        game_loop() #modifies program state
	      @turn_num = @turn_num + 1
	      game_is_over = game_over?
      end
      winner = game_is_over
      return winner
    end

    private

    def init
      # require_relative "./chess/game_engine.rb"  
        player_names = setup()
        @white_player = player_names.first
        @black_player = player_names.last
        @turn_num = 0
        @game = GameEngine.new
    end

    #TODO - FIRST - fix game loop 
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
     "It is #{current_player.to_s}'s turn."
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

    def game_over?
      @game.game_over?
    end

    def current_player
      turn_num.even? ? @white_player : @black_player
    end

    def save_game
      puts "Please enter a filename to save."
      filename = gets.chomp
      if File.exists?(filename)
        puts "Are you sure you want to overwrite #{filename}? (Y/N)"
        answer = gets.chomp
        if /[Yy]([Ee][Ss])?/ =~  answer
          overwrite = true
        end
        if overwrite
          begin
            File.open(filename, 'w') {|f| f.write self.to_yaml}
          rescue
            puts "Sorry. Save error. Returning to game."
          end
        end
      else
        begin
            File.open(filename, 'w') {|f| f.write self.to_yaml}
        rescue
            puts "Sorry. Save error. Returning to game."

        end
      end
      puts "Would you like to quit? (Y/N)"
      quit = gets.chomp      
      if /[Yy]([Ee][Ss])?/ =~  quit
        puts "Thanks for playing!"
	      exit!
      end
   end

   def receive_move
   end

    public
    def load_game
      puts "Give a filename."
      filename = gets.chomp
      begin
        other_game = yaml.load_file(filename)
        @game = other_game.game
        @turn_num = other_game.turn_num
        @white_player = other_game.white_player
        @black_player = other_game.black_player
      rescue
        puts "Sorry. File load error. Starting new game."
        init()
      end
    end
  end

end
include Chess
chess = Chess::Game.new
chess.play
