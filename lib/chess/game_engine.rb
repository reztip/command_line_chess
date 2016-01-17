#game_engine.rb
require_relative "../game.rb"
require_relative "./pieces.rb"
require_relative "./board.rb"
require_relative "./board_characters.rb"  
require_relative "./game_engine.rb"  
module Chess
 class GameEngine
   attr_reader :board
   def initialize
     @board = Board.new
   end

   def valid_moves(position) # position should be in form A5
     position_x = position[0].upcase
     position_y = position[-1].to_i
     piece = @board.piece_at(position_x, position_y)
     return nil if piece.nil? #quick optimization, also prevents runtime errors
     return @board.piece_moves(piece)
   end

   def to_s
    @board.to_s
   end

   def pretty_location_representation(pos)
     x,y = *pos
     a = (y +  1).to_s #y is the row number
     b = (x + 65).chr
     return b+a
   end

   def checkmate?(turn_num) #exhaustive search of team's possible moves, quite expensive... 
     #means that the current plyaer (even == white) is in check
     return true if king_is_dead?(turn_num)
     return false unless in_check?(turn_num)
     color = turn_num.even? ? :white : :black
     friendly_piece_list = color == :white ? @board.white_list : @board.black_list
     friendly_piece_list.each do |piece|
       pos = piece.position
       loc = pretty_location_representation(pos)
       v_moves = @board.piece_moves(piece) 
       v_moves.each do |move|
        dest = pretty_location_representation(move) 
        old_piece = piece_at(dest)
	      @board.move_piece(loc, dest)
	      return false if !in_check?(turn_num)
	      @board.unmake_move(piece, old_piece, loc, dest, color)
       end
     end
     return true
   end

   def in_check?(turn_num)
     color = turn_num.even? ? :white : :black
     enemy_piece_list = color == :white ? @board.black_list : @board.white_list
     friendly_piece_list = color == :white ? @board.white_list : @board.black_list
     king = friendly_piece_list.find {|piece| piece.type == :king} 
     @board.reorder_enemy_pieces_around(king)
     #p enemy_piece_list.map {|pc| "#{pc.color} #{pc.type}: #{pc.location} & distance = #{pc.dist_from(king)}"}
     enemy_piece_list.each do |piece| 
        v_moves  = @board.piece_moves(piece)
        return true if !v_moves.nil? && v_moves.include?(king.position)
     end
     return false
   end
   def is_valid?(from, to, turn_number) #currently a stub
    @board.is_valid?(from, to, turn_number)
   end

   def piece_at(pos) #pos should be a string like "A1" or array like ["A", 3]
    @board.piece_at(pos[0], pos[1].to_i)
   end
   def make_move(from,to)
    @board.move_piece(from,to)
   end
    def king_is_dead?(num)
      color = (num.even? ? :white : :black)
      if color == :white
        @board.white_list.each do |p|
          return false if p.type == :king
        end
        return true
      else
        @board.black_list.each do |p|
          return false if p.type == :king
        end
        return true
      end
    end

 end

end
