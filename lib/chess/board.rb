#board.rb
require_relative "../game.rb"
require_relative "./pieces.rb"
require_relative "./board.rb"
require_relative "./board_characters.rb"  
require_relative "./game_engine.rb"  
require 'set'

module Chess
  class Board
    attr_reader :n, :row_labels, :column_labels, :black_list, :white_list
    @@n = 8
    @row_labels = ((1..@@n).to_a).map {|x| x.to_s}
    @@column_labels = ('A'..'H').to_a
    @@label_map = {'A' => 1, 'B' => 2, 'C' => 3, 'D'=> 4, 'E' => 5, 'F' => 6, 'G' => 7, 'H' => 8}
    def initialize
    @white_list = []
    @black_list = []
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
      return @board[y - 1][x - 1]
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

    def checkmate? #TODO STUB
    end

    def is_valid?(mv, turnnum)
      from = mv.first
      to = mv.last
      player_color = ( turnnum.even? ? :white : :black)
      piece  = piece_at(from.first + 1, from.last + 1)
      return false if piece.nil?
      color = piece.color
      return false if player_color != color
      return is_valid( to, piece,color)
    end

    

    def is_valid( to, piece, color)
      legal_moves = piece_moves(piece) #a list of positions of form [0, 6] which is the position's piece on the array
      return false if legal_moves.nil? || legal_moves.empty?
      return legal_moves.include?(to)
    end

    def other_color(color)
      return (color == :white) ? :black : :white
    end


    def move_piece(from, to) #from should be like "A3", to should be like "B5"
      piece = piece_at(from[0], from[-1].to_i)
      set_piece(to[0], to[-1].to_i, piece) 
      remove_piece(from)
      piece.update_position([to[1].to_i - 1 , to[0].ord - 65])
      return nil
    end
    def unmake_move(moved, deleted, source, dest, color)
     enemies = color == :white ? @black_list : @white_list
     enemies << deleted if !deleted.nil?
     set_piece(source[0], source[1].to_i, moved)
     set_piece(dest[0], dest[1].to_i, deleted) if !deleted.nil?
     nil
    end
   def remove_piece(from)
   	row_num = from[1].to_i - 1
	col_num = x_coord(from[0])
	piece  = piece_at(from[0], from[1].to_i)
	return nil if piece.nil?
	@board[row_num][col_num] = nil
	@white_list.delete(piece) if piece.color == :white
	@black_list.delete(piece) if piece.color == :black
	nil
   end
    def reorder_enemy_pieces_around(piece)
	enemy_list = piece.color == :white ? @black_list : @white_list
	enemy_list.sort_by! {|p| piece.dist_from(p) }

    end
    def x_coord(character)
      return character.ord - 65
    end

    def nice_string(array)
      return (array.last + 65).chr ,  (array.first + 1)
    end

    def piece_moves(piece)
      return nil if piece.nil? || !piece.is_a?(Pieces)
      potential_moves = piece.potential_moves #a list of positions of form [0, 6] which is the position's piece on the array
      #p potential_moves
      return nil if potential_moves.nil? || potential_moves.empty?
      potential_moves.select! {|pos| piece_at(*nice_string(pos)).nil? || piece_at(*nice_string(pos)).color == other_color(piece.color) } 
      potential_moves.select! {|pos| pos != piece.position}
      actual_moves = actual_possible_moves(piece, potential_moves)
      return actual_moves
    end

    def actual_possible_moves(piece, potential_moves)

      p_type = piece.type
      case p_type

      when :king, :knight #unrestricted mvoement except for same-color pieces
        return potential_moves

      when :pawn
        return pawn_moves(piece, potential_moves)

      when :bishop
        return bishop_moves(piece, potential_moves)
      when :rook
        return rook_moves(piece, potential_moves)
      else #:queen
        return queen_moves(piece, potential_moves)
      end
    end
    def pawn_moves(piece, potential_moves)
      color = piece.color
      pm = Array.new(potential_moves)
      pm.each do |mov|
       x = (mov.last + 65).chr 
       y = mov.first + 1
       other_piece = piece_at(x,y)
       #pawn cannot move diagonally if diagonal position is empty
       potential_moves.delete(mov) if other_piece.nil? && mov.last != piece.position.last
       next if other_piece.nil?
       #pawn cannot move to a position if it is occupied by a team member
       potential_moves.delete( mov) if other_piece.color == color      
       #pawn cannot move to position if there is a different color in front of it 
       potential_moves.delete(mov) if other_piece.color != color && mov.last == piece.position.last
       #pawn cannot move up two spaces if there is a piece blocking it
       dist = (mov.first - piece.position.first).abs + (mov.last - piece.position.last).abs
      end
      if color == :white && piece.position.first == 1
        potential_moves.delete([piece.position.first + 2, piece.position.last]) if !piece_at(*nice_string([piece.position.first + 1, piece.position.last])).nil? 
      end

      if color == :black && piece.position.first == 6
        potential_moves.delete([piece.position.first - 2, piece.position.last]) if !piece_at(*nice_string([piece.position.first - 1, piece.position.last])).nil? 
      end
      return potential_moves 
    end

    def bishop_moves(piece, moves)
      loc = piece.location
      x = loc.first
      y = first.last
      i = x + 1
      j = y + 1
      blocked_count = 0
      until (i > 7 || j > 7)
        other_piece = piece_at(i+1, j+1)
        blocked_by_same_team = (!other_piece.nil? && other_piece.color == piece.color)
        blocked_by_other_team = (!other_piece.nil? && other_piece.color != piece.color)
        blocked_count = blocked_count + 1 if blocked_by_other_team
        moves.delete([i,j]) if (blocked_by_same_team || blocked_count > 1)
        i = i + 1
        j = j + 1
      end
      i = x + 1 ; j = y - 1; blocked_count = 0
      until (i > 7 || j < 0)
        other_piece = piece_at(i+1, j+1)
        blocked_by_same_team = (!other_piece.nil? && other_piece.color == piece.color)
        blocked_by_other_team = (!other_piece.nil? && other_piece.color != piece.color)
        blocked_count = blocked_count + 1 if blocked_by_other_team
        moves.delete([i,j]) if (blocked_by_same_team || blocked_count > 1)
        i = i + 1
        j = j - 1
      end
       i = x -1 ; j = y + 1; blocked_count = 0
      until (i < 0 || j > 7)
        other_piece = piece_at(i+1, j+1)
        blocked_by_same_team = (!other_piece.nil? && other_piece.color == piece.color)
        blocked_by_other_team = (!other_piece.nil? && other_piece.color != piece.color)
        blocked_count = blocked_count + 1 if blocked_by_other_team
        moves.delete([i,j]) if (blocked_by_same_team || blocked_count > 1)
        i = i - 1
        j = j + 1
      end
       i = x -1 ; j = y - 1; blocked_count = 0
      until (i < 0 || j < 0)
        other_piece = piece_at(i+1, j+1)
        blocked_by_same_team = (!other_piece.nil? && other_piece.color == piece.color)
        blocked_by_other_team = (!other_piece.nil? && other_piece.color != piece.color)
        blocked_count = blocked_count + 1 if blocked_by_other_team
        moves.delete([i,j]) if (blocked_by_same_team || blocked_count > 1)
        i = i - 1
        j = j - 1
      end
      return moves
    end

    def rook_moves(piece, moves)
      pos = piece.position
      row = pos.first
      col = pos.last
      filter_right_pieces(piece,moves)
      filter_left_pieces(piece,moves)
      filter_above_pieces(piece,moves)
      filter_below_pieces(piece,moves)
      moves.delete(piece.position)
      return moves
    end
    def filter_right_pieces(piece, moves)
      pos = piece.position
      y = pos.first
      x = pos.last
      blocked = false
      hit_count = 0
      (x..7).each do |i|
        moves.delete([y,i]) if blocked || hit_count > 1
        neighbor = piece_at(*nice_string([y,i+1])) if i != 7
        blocked ||= !neighbor.nil? && neighbor.color == piece.color
        hit_count = hit_count + 1 if !neighbor.nil? && neighbor.color == other_color(piece.color)
      end
      return moves
    end
    def filter_left_pieces(piece, moves)
      pos = piece.position
      y = pos.first
      x = pos.last
      blocked = false
      hit_count = 0
      (0..x).reverse_each do |i|
        moves.delete([y,i]) if blocked || hit_count > 1
        neighbor = piece_at(*nice_string([y,i-1])) if i != 0
        blocked ||= !neighbor.nil? && neighbor.color == piece.color
        hit_count = hit_count + 1 if !neighbor.nil? && neighbor.color == other_color(piece.color)
      end
      return moves
    end
    def filter_above_pieces(piece, moves)
      pos = piece.position
      y = pos.first
      x = pos.last
      blocked = false
      hit_count = 0
      (y..7).each do |j|
        moves.delete([j,x]) if blocked || hit_count > 1
        neighbor = piece_at(*nice_string([j+1,x])) if j != 7
        blocked ||= !neighbor.nil? && neighbor.color == piece.color
        hit_count = hit_count + 1 if !neighbor.nil? && neighbor.color == other_color(piece.color)
      end
      return moves
    end
    def filter_below_pieces(piece, moves)
      pos = piece.position
      y = pos.first
      x = pos.last
      blocked = false
      hit_count = 0
      (0..y).reverse_each do |j|
        moves.delete([j,x]) if blocked || hit_count > 1
        neighbor = piece_at(*nice_string([j-1,x])) if j != 0
        blocked ||= !neighbor.nil? && neighbor.color == piece.color
        hit_count = hit_count + 1 if !neighbor.nil? && neighbor.color == other_color(piece.color)
      end
      return moves
    end

    def queen_moves(piece, moves)
      mv = Array.new(moves)
      r = rook_moves(piece, moves)
      r = [] if r.nil?
      b = bishop_moves(piece, mv)
      b = [] if b.nil?
      return r + b
    end

    def parse_move(move)
      x = @@label_map[move[0].upcase] - 1
      y = move[1].to_i - 1
      return [x,y]
    end

    def set_piece(x, y, piece) #x is A-H, y is 1-8
      # x = (@@column_labels.include?(x) ? @@label_map[x] : x)
      x = (@@column_labels.include?(x.to_s.upcase) ? @@label_map[x.to_s.upcase] : x) if  x =~ /[[:alpha:]]/
      @board[y - 1][x - 1] = piece
    end

    def fill_board
      fill_white()
      fill_black()  
    end

    def fill_white
      ('A'..'H').each do |x|
        col = @@label_map[x] - 1
        #first position is the row index, then the column index. Position is raw row/column. accessible as b[r][c] for [r,c]  as args to Piece
        pawn = Pawn.new(:white, [1, col])
        @white_list << pawn
        set_piece(x, 2, pawn)
      end
      #enter royal pieces
      rook = Rook.new(:white, [0,0])
      @white_list << rook
      set_piece("A", 1, rook)
      rook = Rook.new(:white, [0,7])
      set_piece("H", 1, rook)
      @white_list << rook
      
      knight = Knight.new(:white, [0, 1])
      @white_list << knight
      set_piece("B", 1, knight)
      knight = Knight.new(:white, [0, 6])
      @white_list << knight
      set_piece("G",1, knight)
      
      bishop = Bishop.new(:white, [0, 2])
      @white_list << bishop
      set_piece("C", 1, bishop)
      bishop = Bishop.new(:white, [0, 5])
      @white_list << bishop
      set_piece("F", 1, bishop)
      queen = Queen.new(:white, [0, 3])
      @white_list << queen
      set_piece( "D", 1,queen)
      king = King.new(:white, [0,4])
      @white_list << king
      set_piece("E",1, king)
    end

    def fill_black
      ('A'..'H').each do |x|
        col = @@label_map[x] - 1
        #first position is the row index, then the column index. Position is raw row/column. accessible as b[r][c]
        pawn = Pawn.new(:black, [6, col])
        @black_list << pawn
        set_piece(x, 7, pawn)
      end
      #enter royal pieces
      rook = Rook.new(:black, [7,0])
      @black_list << rook
      set_piece("A", 8, rook)
      rook = Rook.new(:black, [7,7])
      @black_list << rook
      set_piece("H", 8, rook)

      knight = Knight.new(:black, [7, 1])
      set_piece("B", 8, knight)
      @black_list << knight
      knight = Knight.new(:black, [7, 6])
      set_piece("G",8, knight)
      @black_list << knight
      
      bishop = Bishop.new(:black, [7, 2])
      set_piece("C", 8, bishop)
      @black_list << bishop
      bishop = Bishop.new(:black, [7, 5])
      set_piece("F", 8,bishop)
      @black_list << bishop
      queen = Queen.new(:black, [7,3])
      set_piece( "D", 8, queen)
      king = King.new(:black, [7,4])
      set_piece( "E", 8, king)
      @black_list << bishop
    end


    def blank_row #an inner blank_row
      return "   " + (['--']*16 + ["\n"]).join
    end



    def actual_row(col) #i between 1 and 8, return as string
      s = "|"
      (1..8).each do |j|
        x = piece_at(j,col)
        s << (x.nil? ?  " " : x.to_s) + " | "
      end
      s << "\n"
      s = col.to_s.rjust(2, " ") + " " + s
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
    def equal?(other)
     !other.nil? && other.color == @color && other.type == @type && other.position == @position
    end
    def ==(other)
     !other.nil? && other.color == @color && other.type == @type && other.position == @position
     end
    def eql?(other)
     !other.nil? && other.color == @color && other.type == @type && other.position == @position
    end
    def to_s
      return @representation
    end
    
    def dist_from(other)
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
      return px.select {|pos| pos.first.between?(0,7) && pos.last.between?(0,7)}
    end
  end

  class Bishop < Pieces
    def initialize(color, position)
      super(:bishop, color, position)
    end

    def potential_moves
      row = @position.first
      col  = @position.last
      pos = []
      (1..8).each do |r|
        break if (row + r > 7 || col + r > 7)
	pos << [row + r, col + r]
      end
      (1..8).each do |r|
        break if (row + r > 7 || col - r < 0)
	pos << [row + r, col - r]
      end
      (1..8).each do |r|
        break if (row - r < 0 || col + r > 7)
	pos << [row - r, col + r]
      end
      (1..8).each do |r|
        break if (row - r < 0 || col - r < 0)
	pos << [row - r, col - r]
      end
      return pos 
    end
  end
  class Queen < Pieces
    def initialize(color, position)
      super(:queen, color, position)
    end
    def potential_moves
      row = @position.first
      col  = @position.last
      pos = []
      (1..8).each do |r|
        break if (row + r > 7 || col + r > 7)
	pos << [row + r, col + r]
      end
      (1..8).each do |r|
        break if (row + r > 7 || col - r < 0)
	pos << [row + r, col - r]
      end
      (1..8).each do |r|
        break if (row - r < 0 || col + r > 7)
	pos << [row - r, col + r]
      end
      (1..8).each do |r|
        break if (row - r < 0 || col - r < 0)
	pos << [row - r, col - r]
      end
       positions = pos 
       (0...row).each do |x|
         positions << [x, col]
         end
      (row...8).each do |x|
         positions << [x, col]
       end
       (0...col).each do |y|
         positions << [row, y]
       end
       (col...8).each do |y|
         positions << [row, y]
       end
       positions.delete([row, col])
       return positions
    end
  end

  class King < Pieces
    def initialize(color, position)
      super(:king, color, position)
    end
    def potential_moves
      pos_x = @position.first
      pos_y = @position.last
      x = [ [pos_x, pos_y + 1],
        [pos_x, pos_y - 1],
        [pos_x + 1, pos_y + 1],
        [pos_x + 1, pos_y - 1],
        [pos_x - 1, pos_y + 1],
        [pos_x - 1, pos_y - 1],
        [pos_x + 1, pos_y],
        [pos_x - 1, pos_y]
      ]
      x.select! {|pos| pos.first.between?(0,7) && pos.last.between?(0,7)}
      return x
    end
  end
end
include Chess
# a = King.new
# b = Board.new
# puts b.to_s
