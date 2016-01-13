require './spec_helper.rb'
module Chess
  describe Board do
    describe "#piece_at" do
      before(:each) do
        @board = Board.new
      end
      context "blank board" do
        it "should give back the right piece" do
	expect(@board.piece_at('B',1)).to eq Knight.new(:white, [0,1]) 
	end
	it "" do
	  ('A'..'H').each do |j|
	    val = j.ord - 64 - 1 
	    expect(@board.piece_at(j, 2)).to eq Pawn.new(:white, [1, val])
	  end
	end
	it "should give back the black king at position [7, 4]" do
	  expect(@board.piece_at('E',8)).to eq King.new(:black, [7,4])
	end
      end
    end
  end
end
