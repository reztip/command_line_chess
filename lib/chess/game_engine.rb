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

   def valid_moves(position) # position should be
     position_x = position[0].upcase
     position_y = position[-1].to_i
     piece = @board.piece_at(position_x, position_y)
     return nil if piece.nil? #quick optimization, also prevents runtime errors
     potential_moves = piece.potential_moves
     legal_moves = @board.legal_moves(piece, potential_moves)
     if !legal_moves
      return nil
     else
      return legal_moves
    end
   end

   def to_s
    @board.to_s
   end

   def checkmate?
    @board.checkmate?
   end


   def is_valid?(move) #currently a stub
    @board.is_valid?(move)
   end

   def piece_at(pos)
    @board.piece_at(pos[0].upcase, pos[-1].to_i)
   end



 end

end
