require_relative "../chess.rb"
module Chess

  class Pieces
    attr_reader :representation, :color, :position, :type
    @@types = [:pawn, :rook, :knight, :bishop, :queen, :king]
    @@colors = [:black, "black", :white, "white"]
    def intialize(type, color, position)
      @color = color
      @type = type
      @position = position
      @representation = rep_map[@type][@color]
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
