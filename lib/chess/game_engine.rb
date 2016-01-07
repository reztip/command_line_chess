require_relative "../chess.rb"

module Chess
 class GameEngine
   def initialize
     @board = Board.new
   end

   def valid_moves(position) # position should be 
     piece = @board.piece_at(position)
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



 end

end
