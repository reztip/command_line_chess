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
    attr_reader :turn_num, :white_player, :black_player, :game
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
      game_is_over = false 
      until game_is_over
        print "Would you like to save the game? (Y/N) "
      	save = gets.chomp
	      if /[Yy]([Ee][Ss])?/ =~  save
          save_game()
	      end
        in_check = current_player_in_check?
        notify_current_player if in_check
	      game_is_over ||= checkmate?(@turn_num) if in_check
        break if game_is_over
        game_loop() #modifies program state and makes player move his/her piece
	      @turn_num = @turn_num + 1
      end
      puts ("#{ current_player()} has been defeated!")
    end

    private

    def init
        player_names = setup()
        @white_player = player_names.first
        @black_player = player_names.last
        @turn_num = 0
        @game = GameEngine.new
    end

    #TODO - FIRST - fix game loop 
    def game_loop
     puts @game.to_s
     puts "It is #{current_player()}'s turn."
     move = receive_move()
     from = move.first #something like A2
     to = move.last #something like B3
     is_valid = @game.is_valid?(from, to, @turn_num) #can the current player move  a piece from->to?
     until is_valid
       move = receive_move()
       from = move.first
       to = move.last
       piece = @game.piece_at(from) #what is the current piece?
       puts "You have selected a #{piece.type.to_s.upcase} at #{from} to move to #{to}."
       is_valid = @game.is_valid?(from, to, @turn_num)
       puts "Sorry. not a legal move. please choose again." unless is_valid
     end
     puts "Moving from #{from} to #{to}."
     @game.make_move(from, to)
     puts @game.to_s
     nil
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

    def checkmate?(turn) #say :white or :black
      @game.checkmate?(turn)
    end


    def current_player
      turn_num.even? ? @white_player : @black_player
    end
    def current_player_in_check?
      return @game.in_check?(@turn_num)
    end
    def notify_current_player
      puts "#{current_player()} is now in check!"
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
            filename = filename + '.yml' if filename.slice(-4..-1) != '.yml'
            File.open(filename , 'w') {|f| f.write self.to_yaml}
          rescue
            puts "Sorry. Save error. Returning to game."
          end
        end
      else
        begin
            filename = filename + '.yml' if filename.slice(-4..-1) != '.yml'
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
    #receive move should return something like ['A2', 'B3']
    def receive_move() #a request to move a piece from something to somewhere else
     print "Where is the piece you want to move (e.g., B2)? "
     from = gets.chomp.upcase
     valid_selection = false
     until valid_selection
       valid_selection = (from =~ /[A-Ha-h][1-8]/)
       break if valid_selection
       print "Sorry, not a valid place on the board. Try something like A7. "
       from = gets.chomp
     end
     m1 = from
     print "Where would you like to move the piece to? "
     to = gets.chomp.upcase
     valid_selection = false
     until valid_selection
       valid_selection = (to  =~ /[A-Ha-h][1-8]/)
       break if valid_selection
       print "Sorry, not a valid place on the board. Try something like A6. "
       to = gets.chomp
     end
     m2 = to
     return [m1, m2]
    end

    def load_game
      puts "Give a filename."
      filename = gets.chomp 
      filename = filename + ".yml" if filename.slice(-4..-1) != '.yml'
      begin 
        other_game = YAML::load_file(filename)
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
# include Chess
# chess = Chess::Game.new
# chess.play
