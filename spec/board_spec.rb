require './spec_helper.rb'
module Chess
  describe Board do
    describe "#piece_at" do
      before(:each) do
        @board = Board.new
      end
      context "blank board" do
        it "should give back the right piece" do
	expect(@board.piece_at('A',1)).to eq Knight.new(:white, [0,1]) 
	end
	it "should give back a pawn in position [1, j] for j in (1..8)" do
	  (1..8).each do |j|
	    expect(@board.piece_at('B', j)).to eq Pawn.new(:white, [1, j])
	  end
	end
	it "should give back the black king at position [7, 4]" do
	  expect(@board.piece_at('H',5)).to eq King.new(:black, [7,4])
	end
      end
    end
  end
end
