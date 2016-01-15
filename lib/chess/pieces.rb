# pieces.rb
require_relative "../game.rb"
require_relative "./pieces.rb"
require_relative "./board.rb"
require_relative "./board_characters.rb"  
require_relative "./game_engine.rb"  

module Chess

  class Pieces
    attr_reader :representation, :color, :position, :type
    @@types = [:pawn, :rook, :knight, :bishop, :queen, :king]
    @@colors = [:black, "black", :white, "white"]
    @@REP_MAP = {nil => " ", :pawn => {:black => BLACK_PAWN_REPRESENTATION, :white => WHITE_PAWN_REPRESENTATION},
     :king => {:white => WHITE_KING_REPRESENTATION, :black => BLACK_KING_REPRESENTATION},
     :queen => {:black => BLACK_QUEEN_REPRESENTATION, :white => WHITE_QUEEN_REPRESENTATION},
     :rook => {:white => WHITE_ROOK_REPRESENTATION, :black => BLACK_ROOK_REPRESENTATION}, 
     :bishop => {:black => BLACK_BISHOP_REPRESENTATION, :white => WHITE_BISHOP_REPRESENTATION}, 
     :knight => {:black => BLACK_KNIGHT_REPRESENTATION, :white => WHITE_KNIGHT_REPRESENTATION}
    }
    @@label_map = {'A' => 1, 'B' => 2, 'C' => 3, 'D'=> 4, 'E' => 5, 'F' => 6, 'G' => 7, 'H' => 8}
    @@label_map_reverse = {1 => 'A', 2 => 'B', 3 => 'C', 4 => 'D', 5 => 'E', 6 => 'F', 7 => 'G', 8 => 'H'}

    def initialize(type, color, position)
      @color = color
      @type = type
      @position = position
      @representation = @@REP_MAP[@type][@color]
    end
    def equal?(other)
     !other.nil? && other.color == @color && other.type == @type && other.position == @position
    end
    def to_s
      return @representation
    end
    
    def dist_from(other)
      #puts "other position: #{other.position} & self: #{@position}"
     return (@position[0] - other.position[0]).abs + (@position[1] - other.position[1]).abs
    end
    def location
      return @position.to_s
    end

    def update_position(new_pos)
      @position = new_pos
    end
    
    def potential_moves; end
  end

  class Rook < Pieces
    def initialize(color, position)
      super(:rook, color, position)
    end

    #returns the potential moves a rook can doo
    def potential_moves
       pos_x = @position.first
       pos_y = @position.last
       positions = []
       (0...pos_x).each do |x|
         positions << [x, pos_y]
         end
      (pos_x...8).each do |x|
         positions << [x, pos_y]
       end
       (0...pos_y).each do |y|
         positions << [pos_x, y]
       end
       (pos_y...8).each do |y|
         positions << [pos_x, y]
       end
       positions.delete([pos_x, pos_y])
       return positions
    end
  end

  class Pawn < Pieces
    def initialize(color, position)
      super(:pawn, color, position)
    end

    #this needs to be heavily filtered, since pawns can move diagonally only if 
    def potential_moves
      row = @position.first
      col = @position.last
      pos = []
      if @color == :white
        if row == 1
	  pos << [row+2, col]
	end
	if row < 7
	  pos << [row + 1, col]
	end
	if col > 0 && row < 7
	  pos << [row + 1, col - 1]
	end
	if col < 7 && row < 7
	  pos << [row + 1, col + 1]
	end
      else
	if row == 6
	  pos << [row - 2, col]
	end
	if row > 0
	  pos << [row -1, col] 
	  if col > 0
	    pos << [row - 1, col - 1]
	  elsif col < 7
	    pos << [row -1, col + 1]
	  end
	end
      end
      return pos
    end
  end

  class Knight < Pieces
    def initialize(color, position)
      super(:knight, color, position)
    end
    def potential_moves
      pos_x = @position.first
      pos_y = @position.last
      px = [ [pos_x + 1, pos_y + 2],[pos_x + 1, pos_y - 2],[pos_x + 2, pos_y + 1], [pos_x + 2, pos_y - 1],[pos_x - 1, pos_y + 2],[pos_x - 1, pos_y - 2],[pos_x - 2, pos_y + 1],[pos_x - 2, pos_y - 1]]
      #puts px
      return px.select {|pos| pos.first.between?(0,7) && pos.last.between?(0,7)}
    end
  end

  class Bishop < Pieces
    def initialize(color, position)
      super(:bishop, color, position)
    end

    def potential_moves
      pos_x = @position.first
      pos_y = @position.last

      i = 1
      j = 1
      positions = []
      until (pos_x + i >7 || pos_y + j > 7)
        positions << [pos_x + i, pos_y + j]
        i = i+1; j = j+ 1
      end
      i = -1; j = -1
      until (pos_y + j < 0  || pos_x + i < 0)
        positions << [pos_x + i, pos_y + j]
        i = i - 1; j = j - 1
      end
      i = 1; j = -1
      until (pos_y + j < 0  || pos_x + i > 7)
        positions << [pos_x + i, pos_y + j]
        i = i + 1; j = j - 1
      end
      i = -1, j = 1
      until (pos_y + j > 7  || pos_x + i < 0)
        positions << [pos_x + i, pos_y + j]
        i = i - 1; j = j + 1
      end

      return position
    end
  end
  class Queen < Pieces
    def initialize(color, position)
      super(:queen, color, position)
    end
    def potential_moves
      pos_x = @position.first
      pos_y = @position.last
      i = 1
      j = 1
      positions = []
      until (pos_x + i >7 || pos_y + j > 7)
        positions << [pos_x + i, pos_y + j]
        i = i+1; j = j+ 1
      end
      i = -1; j = -1
      until (pos_y + j < 0  || pos_x + i < 0)
        positions << [pos_x + i, pos_y + j]
        i = i - 1; j = j - 1
      end
      i = 1; j = -1
      until (pos_y + j < 0  || pos_x + i > 7)
        positions << [pos_x + i, pos_y + j]
        i = i + 1; j = j - 1
      end
      i = -1, j = 1
      until (pos_y + j > 7  || pos_x + i < 0)
        positions << [pos_x + i, pos_y + j]
        i = i - 1; j = j + 1
      end
      (0...pos_x).each do |x|
         positions << [x, pos_y]
         end
      (pos_x...8).each do |x|
         positions << [x, pos_y]
       end
       (0...pos_y).each do |y|
         positions << [pos_x, y]
       end
       (pos_y...8).each do |y|
         positions << [pos_x, y]
       end
       return positions
    end
  end

  class King < Pieces
    def initialize(color, position)
      super(:king, color, position)
    end
    def potential_moves
      pos_x = @position.first
      pos_y = @position.y
      [ [pos_x, pos_y + 1],
        [pos_x, pos_y - 1],
        [pos_x + 1, pos_y + 1],
        [pos_x + 1, pos_y - 1],
        [pos_x - 1, pos_y + 1],
        [pos_x - 1, pos_y - 1],
        [pos_x + 1, pos_y],
        [pos_x - 1, pos_y]
      ].select {|pos| pos.first.between?(0,7) && pos.last.between?(0,7)}
    end
  end
end
