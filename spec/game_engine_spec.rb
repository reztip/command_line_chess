require_relative './spec_helper.rb'
module Chess
  #work is easy at this point, all should be done in the board class.
  describe GameEngine do
   before(:each) {@game = GameEngine.new} 
   before(:each) {@white = 0}
   before(:each) {@black = 1}
   describe "#in_check?" do
    it "game has just started" do
      expect(@game.in_check?(@white)).to be false
      expect(@game.in_check?(@black)).to be false
    end
    it "white knight threatens the black king" do
      @game.make_move("B1", "C7")
      piece = @game.board.piece_at("C", 7)
      expect(piece.position).to eq [6,2]
      expect(@game.board.white_list).to include(piece)
      #p @game.valid_moves("C7")
      expect(@game.valid_moves("C7")).to include([7,4])
      expect(@game.in_check?(@black)).to be true
    end
   end
  end

end
