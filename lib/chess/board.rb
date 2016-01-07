require_relative "../chess.rb"

module Chess
  class Board
    attr_reader :n, :row_labels, :column_labels
    @@n = 8
    @@row_labels = ((1..@@n).to_a).map {|x| x.to_s}
    @@column_labels = ('A'..'H').to_a

    def initialize
      #make an 8 by 8 square, starting with nil
      @board = [ [nil] * @@n] * @@n 
      #each entry is a row, each row has n entries (of space)
      #by convention, the first row will be the bottom row, belonging to white
      #the last row will be the top row, belonging to black
      fill_board()
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

  end

end