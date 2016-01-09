require_relative "../chess.rb"
require_relative "./board_characters.rb"
module Chess

  class Pieces
    attr_reader :representation, :color, :position, :type
    @@types = [:pawn, :rook, :knight, :bishop, :queen, :king]
    @@colors = [:black, "black", :white, "white"]
    @@REP_MAP = {nil => "", :pawn => {:black => BLACK_PAWN_REPRESENTATION, :white => WHITE_PAWN_REPRESENTATION},
     :king => {:white => WHITE_KING_REPRESENTATION, :black => BLACK_KING_REPRESENTATION},
     :queen => {:black => BLACK_QUEEN_REPRESENTATION, :white => WHITE_QUEEN_REPRESENTATION},
     :rook => {:white => WHITE_ROOK_REPRESENTATION, :black => BLACK_ROOK_REPRESENTATION}, 
     :bishop => {:black => BLACK_BISHOP_REPRESENTATION, :white => WHITE_BISHOP_REPRESENTATION}, 
     :knight => {:black => BLACK_KNIGHT_REPRESENTATION, :white => WHITE_KNIGHT_REPRESENTATION}
    }
    def initialize(type, color, position)
      @color = color
      @type = type
      @position = position
      @representation = @@REP_MAP[@type][@color]
    end

    def to_s
      return @representation
    end
    
    def valid_moves; end
  end

  class Rook < Pieces
    def initialize(color, position)
      super(:rook, color, position)
    end
  end

  class Pawn < Pieces
  def initialize(color, position)
    super(:pawn, color, position)
    end
  end

  class Knight < Pieces
  def initialize(color, position)
    super(:knight, color, position)
    end
  end

  class Bishop < Pieces
    def initialize(color, position)
      super(:bishop, color, position)
      end
  end
  class Queen < Pieces
    def initialize(color, position)
      super(:queen, color, position)
    end
  end

  class King < Pieces
    def initialize(color, position)
      super(:king, color, position)
    end
  end
end
