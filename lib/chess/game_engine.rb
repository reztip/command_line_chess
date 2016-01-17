#game_engine.rb
require_relative "../game.rb"
require_relative "./pieces.rb"
require_relative "./board.rb"
require_relative "./board_characters.rb"  
require_relative "./game_engine.rb"  
module Chess
 class GameEngine
   def initialize
     @board = Board.new
   end

   def valid_moves(position) # position should be in form A5
     position_x = position[0].upcase
     position_y = position[-1].to_i
     piece = @board.piece_at(position_x, position_y)
     return nil if piece.nil? #quick optimization, also prevents runtime errors
     legal_moves = @board.piece_moves(piece)
     if !legal_moves || legal_moves == []
      return nil
     else
      return legal_moves
    end
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
     color = turn_num.even? ? :white : :black
     friendly_piece_list = color == :white ? @board.white_list : @board.black_list
     friendly_piece_list.each do |piece|
       pos = piece.position
       loc = pretty_location_representation(pos)
       v_moves = @board.piece_moves(piece) 
       v_moves.each do |move|
        dest = pretty_location_representation(move) 
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
     king = friendly_piece_list.find {|piece| piece.is_a? King} 
     @board.reorder_enemy_pieces_around(king)
     enemy_piece_list.each do |piece| 
        loc = pretty_location_representation(piece.position)
	v_moves = valid_moves(loc)
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

 end

end
