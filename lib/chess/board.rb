#board.rb
require_relative "../game.rb"
require_relative "./pieces.rb"
require_relative "./board.rb"
require_relative "./board_characters.rb"  
require_relative "./game_engine.rb"  


module Chess
  class Board
    attr_reader :n, :row_labels, :column_labels
    @@n = 8
    @@row_labels = ((1..@@n).to_a).map {|x| x.to_s}
    @@column_labels = ('A'..'H').to_a
    @@label_map = {'A' => 1, 'B' => 2, 'C' => 3, 'D'=> 4, 'E' => 5, 'F' => 6, 'G' => 7, 'H' => 8}
    def initialize
      #make an 8 by 8 square, starting with nil
      @board = []
     (0..8).each do |i|
        @board << Array.new(8)
      end #each entry is a row, each row has n entries (of space)
      #by convention, the first row will be the bottom row, belonging to white
      #the last row will be the top row, belonging to black
      fill_board()
    end

    def piece_at(x,y) # I operate under the assumption that pieceat is 1-8 or A-H
      # x = (@@column_labels.include?(x) ? @@label_map[x] : x)
      x = (@@column_labels.include?(x.to_s.upcase) ? @@label_map[x.to_s.upcase] : x) if  x =~ /[[:alpha:]]/
      return @board[x - 1][y - 1]
    end

    def to_s
      s = ''
      (1..8).reverse_each do |i|
        s << blank_row()
        s << actual_row(i)
      end
      s << blank_row()
      s << "    " + @@label_map.keys.join('   ')
      return s
    end

    private
    def move_piece(from_x, from_y, to_x, to_y) #from should be like [1,2], to should be like[3,2]
      piece = piece_at(from_x, from_y)
      @board[to_x - 1][to_y - 1] = piece
      @board[from_x -1 ][from_y - 1] = nil
    end


    def fill_board
      fill_white()
      fill_black()  
    end

    def fill_white
      (0..7).each do |col|
        @board[1][col] = Pawn.new(:white, [1, col])
      end
      #enter royal pieces
      @board[0][0] = Rook.new(:white, [0,0])
      @board[0][@@n-1] = Rook.new(:white, [0,@@n-1])

      @board[0][1] = Knight.new(:white, [0, 1])
      @board[0][@@n-2] = Knight.new(:white, [0, @@n - 2])

      @board[0][2] = Bishop.new(:white, [0, 2])
      @board[0][@@n - 3] = Bishop.new(:white, [0,  @@n - 3])

      @board[0][3] = Queen.new(:white, [0, 3])
      @board[0][4] = King.new(:white, [0, 4])
      #end setup
    end
    def fill_black
      require_relative "./pieces.rb"
      (0..7).each do |col|
        # puts @@n
        @board[6][col] = Pawn.new(:black, [6, col])
      end
      #enter royal pieces
      @board[7][0] = Rook.new(:black, [7,0])
      @board[7][@@n-1] = Rook.new(:black, [7,@@n-1])

      @board[7][1] = Knight.new(:black, [7, 1])
      @board[7][@@n-2] = Knight.new(:black, [7, @@n - 2])

      @board[7][2] = Bishop.new(:black, [7, 2])
      @board[7][@@n - 3] = Bishop.new(:black, [7,  @@n - 3])

      @board[7][3] = Queen.new(:black, [7, 3])
      @board[7][4] = King.new(:black, [7, 4])
      #end setup
    end


    def blank_row #an inner blank_row
      return "   " + (['--']*16 + ["\n"]).join
    end



    def actual_row(i) #i between 1 and 8, return as string
      s = "|"
      (1..8).each do |j|
        x = piece_at(i,j)
        s << (x.nil? ?  " " : x.to_s) + " | "
      end
      s << "\n"
      s = i.to_s.rjust(2, " ") + " " + s
      return s #.slice((s.length/2)..-1)
    end
  
  end

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

    def to_s
      return @representation
    end

    def location
      return @position.to_s
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
       return positions
    end
  end

  class Pawn < Pieces
    def initialize(color, position)
      super(:pawn, color, position)
    end

    #this needs to be heavily filtered, since pawns can move diagonally only if 
    def potential_moves
      pos_x = @position.first
      pos_y = @position.last
      positions = []
      if color == :white && pos_y == 1
        positions << [pos_x, pos_y + 2]
        if (pos_x == 0 && pos_y < 7)
          positions << [pos_x, pos_y + 1]
          positions << [pos_x + 1, pos_y + 1]
        
        elsif (pos_x == 7 && pos_y < 7)
          positions << [pos_x, pos_y + 1]
          positions << [pos_x - 1, pos_y + 1]

        elsif pos_y < 7
           positions << [pos_x, pos_y + 1]
           positions << [pos_x - 1, pos_y + 1]
            positions << [pos_x + 1, pos_y + 1]
        end
      else
        if pos_y == 6
          positions << [pos_x, pos_y - 2]
        end
        if (pos_x == 0 && pos_y > 0)
          positions << [pos_x, pos_y - 1]
          positions << [pos_x + 1, pos_y - 1]
        
        elsif (pos_x == 7 && pos_y > 0)
          positions << [pos_x, pos_y - 1]
          positions << [pos_x - 1, pos_y - 1]

        elsif pos_y > 0
           positions << [pos_x, pos_y - 1]
           positions << [pos_x - 1, pos_y - 1]
            positions << [pos_x + 1, pos_y - 1]
        end

      end
      return position
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
      puts px
      return px.select {|pos| pos.first.between(0,7) && pos.last.between(0,7)}
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
include Chess
# a = King.new
# puts Chess.constants
# b = Board.new
# puts b.to_s