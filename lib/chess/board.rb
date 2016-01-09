require_relative "../chess.rb"
require_relative "./board_characters.rb"
module Chess
  class Board
    attr_reader :n, :row_labels, :column_labels
    @@n = 8
    @@row_labels = ((1..@@n).to_a).map {|x| x.to_s}
    @@column_labels = ('A'..'H').to_a
    @@label_map = {'A' => 1, 'B' => 2, 'C' => 3, 'D'=> 4, 'E' => 5, 'F' => 6, 'G' => 7, 'H' => 8}
    def initialize
      #make an 8 by 8 square, starting with nil
      @board = [ [nil] * @@n] * @@n 
      #each entry is a row, each row has n entries (of space)
      #by convention, the first row will be the bottom row, belonging to white
      #the last row will be the top row, belonging to black
      fill_board()
    end

    def piece_at(x,y) # I operate under the assumption that 
      y = (@@column_labels.include?(y) ? @@label_map[y] : y)
      return @board[x - 1][y]
    end

    def to_s
      b_board = blank_board()
      b_board
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
      @board[0][n] = Rook.new(:white, [0,n])

      @board[0][1] = Knight.new(:white, [0, 1])
      @board[0][n-1] = Knight.new(:white, [0, n - 1])

      @board[0][2] = Bishop.new(:white, [0, 2])
      @board[0][n - 2] = Bishop.new(:white, [0,  n - 2])

      @board[0][3] = Queen.new(:white, [0, 3])
      @board[0][4] = King.new(:white, [0, 4])
      #end setup
    end
    def fill_black
      (0..7).each do |col|
        @board[6][col] = Pawn.new(:black, [6, col])
      end
      #enter royal pieces
      @board[7][0] = Rook.new(:black, [7,0])
      @board[7][n] = Rook.new(:black, [7,n])

      @board[7][1] = Knight.new(:black, [7, 1])
      @board[7][n-1] = Knight.new(:black, [7, n - 1])

      @board[7][2] = Bishop.new(:black, [7, 2])
      @board[7][n - 2] = Bishop.new(:black, [7,  n - 2])

      @board[7][3] = Queen.new(:black, [7, 3])
      @board[7][4] = King.new(:black, [7, 4])
      #end setup
    end




    def blank_board
      middle_row = (0..17).map {|x| x.even? ? '|' : ' '}
      board = []
      (0..17).each do |i|
        board += [
          x.even? ? blank_row() : middle_row
        ]
      end
      return board
    end

    def blank_row #an inner blank_row
      return ['-']*17
    end


  end

end