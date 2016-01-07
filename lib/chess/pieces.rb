require_relative "../chess.rb"
module Chess

  class Pieces
    @@types = [:pawn, :rook, :knight, :bishop, :queen, :king]
    @@colors = [:black, "black", :white, "white"]
    def intialize(type, color)
      @color = color
      @type = type
    end
  end

  def Rook
    def initialize(color)
      super(:rook, color)
    end
  end

  def Pawn
  def initialize(color)
    super(:pawn, color)
    end
  end

  def Knight
  def initialize(color)
    super(:knight, color)
    end
  end

  def Bishop
    def initialize(color)
      super(:bishop, color)
      end
  end
  def Queen
    def initialize(color)
      super(:queen, color)
    end
  end

  def King
    def initialize(color)
      super(:king, color)
    end
  end
end
