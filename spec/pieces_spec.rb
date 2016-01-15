require_relative './spec_helper.rb'
module Chess
  describe Pieces do
   let(:board) {Board.new}
   describe  "#==" do
    it "equal pieces" do
      p = Pawn.new(:white, [1, 0])
      p2 = Pawn.new(:white, [1,0])
      expect(p).to eq p2
    end
    it " same colors of  pieces" do
      p = Pawn.new(:white, [1,0])
      p2 = Pawn.new(:white, [2, 2])
      expect(p).not_to eq p2
    end
    it "same position, diff color" do
	p = Rook.new(:white, [2, 3])
	p2 = Rook.new(:black, [2,3])
    end
    it "other piece is nil" do
      expect(Pawn.new(:white, [1,1])).not_to eq nil
    end
   end
   describe "#dist_from" do
    it "has a distance from itself of zero" do
      p = Pieces.new(:king, :black, [1,1])
      expect(p.dist_from(p)).to eq 0
    end
    it "has a distance from an adjacent piece of zero" do
      p = Pieces.new(:king, :black, [1,1])
      p1 = Pieces.new(:queen, :black, [1,2])
      expect(p.dist_from(p1)).to eq 1
    end
    it "has a dist of 7 across the board in one dimension" do
	p = Rook.new(:white, [0, 0])
	p1 = Rook.new(:black, [7, 0])
	expect(p.dist_from(p1)).to eq 7
    end
    it "has a dist of 14 across the entire board" do
	p = Rook.new(:white, [0, 0])
	p1 = Rook.new(:black, [7, 7])
	expect(p.dist_from(p1)).to eq 14
    end
   end
   describe "#potential_moves" do
     context Rook do
	it "is on the left corner" do
      	 piece = Rook.new(:white, [0,0])
	 arr = []
	 (1..7).each do |i|
	   arr << [0, i]
	   arr << [i,0]
	 end
	 expect(arr).to match_array(piece.potential_moves)
	end
	it "is is on position C4 [5, 4]" do
          r = Rook.new(:black, [5,4])
	  arr = []
	  (0..4).each do |y|
	    arr << [y, 4]
	  end
	  (6..7).each do |y|
	    arr << [y, 4]
	  end
	  (0..3).each do |x|
	    arr << [5, x]
	  end
	  (5..7).each do |x|
	    arr << [5, x]
	  end
	  expect(arr).to match_array(r.potential_moves)
	end
     end

     context Knight do
	it "gives [[2,1], [0,1], [1,3]] for the bottom left white knight" do 
	#knight starts in position [0, 1]
	x = [[2,2], [1,3], [2,0]]
	knight = Knight.new(:white, [0,1])
	expect(knight.potential_moves).to match_array(x)
	end
     end

     context Pawn do
	it "works correctly for pawn on the ledge" do
	  pawn = Pawn.new(:white, [1,0])
	  x = [[3, 0], [2,0], [2,1]]
	  expect(pawn.potential_moves).to match_array(x)
	end
	it "works fine for a pawn on the east side" do
	  pawn = Pawn.new(:black, [5,7])
          x = [[4,6],[4,7]]	  
	  expect(pawn.potential_moves).to match_array(x)
	end
	it "works ok for a pawn in the middle of the board" do
	  pawn = Pawn.new(:white, [2,2])
	  x = [[3,2], [3,1], [3,3]]
	  expect(pawn.potential_moves).to match_array(x)
	end
     end
     context Bishop do
       it "gives full swath for the corner" do
	bish = Bishop.new(:white, [0,0])
	pos = []
	(1..7).each {|i| pos << [i,i]}
	expect(bish.potential_moves).to match_array(pos)
       end
       it "gives everything except on the diagonals" do
 	bish = Bishop.new(:black, [1,1])
	pos = []
	(0..7).each {|i| pos << [i,i] if i != 1}
	pos << [0,2]
	pos << [2,0]
	expect(bish.potential_moves).to match_array(pos)
       end
     end
     context King do
	it "gives the right result for black starting position" do
	  king = King.new(:black, [7,4])
	  x = [[7,3], [7,5], [6,3], [6,4], [6,5]]
	  expect(king.potential_moves).to match_array(x)
	end
	it "gives the right result for white in the middle of the board" do 
	  king = King.new(:white, [4,4])
	  x = [[3,3], [5,5], [3,5],[5,3], [5,4], [3,4], [4,5], [4,3]]
	  expect(king.potential_moves).to match_array(x)
        end
     end
   end
  end
end
