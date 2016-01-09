require_relative "../chess.rb"
require_relative "./board_characters.rb"



module Chess
  class Board
    attr_reader :n, :row_labels, :column_labels, :board
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
      y = (@@column_labels.include?(y.to_s.upcase) ? @@label_map[y.to_s.upcase] : y) if  y =~ /[[:alpha:]]/
      return @board[x - 1][y - 1]
    end

    def to_s
      b_board = blank_board()

      board_rows = b_board.each_with_index.map do |row, i| # i = 0 to 16 inclusive
        (i.odd? ? (8  -  i/2).to_s.rjust(2, ' ') : "  ") + row.join
      end
      b = board_rows.join("\n")
      bottom_row = "  " + @@label_map.keys.map {|x| "  " + x.to_s}.join(' ')
      puts b + "\n" + bottom_row
    end

    private

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



        public
    def blank_board
      # in effect i will be in 1, 3, 5, 7, ... 15.  
      # middle_row = (0..16).map {|x| x.even? ? '| ' : "#{Pawn.new(:white, [1,1]).to_s} "}
      #map 1 to row 0
      #map 3 to board row 1
      #map 13 to board row 6
      #map 15 to board row 7
      board = []
      (0..16).each do |i|
        board += [
          i.even? ? blank_row() : other_row(@@n - i - 1) #i will be odd here
        ]
      end
      # board.each do |row|
        # puts row.join
      # end
      return board
    end

    def blank_row #an inner blank_row
      return ['--']*16 + ['-']
    end

    def other_row(i) #row number
      r = (0..16).map  do |j|
        x = piece_at(i/2 +  1, j/2 + 1)
        j.even? ? '| ' : (x.nil? ? "  " : x.to_s + " ")
      end
      # p r
      return r
    end


  end
end

def main
  include Chess
  b = Board.new
  x = 1
  b.board.each do |row|
     row.each do |piece|
      piece = " " if piece.nil?
      puts piece.to_s + ": #{piece.color.to_s} + #{piece.type.to_s}, piece number #{x} at location #{piece.location()}" if piece.is_a? Pieces
      x = x + 1
    end
     # puts a
  end
  puts nil
end