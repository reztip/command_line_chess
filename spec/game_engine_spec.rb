require_relative './spec_helper.rb'
module Chess
  #work is easy at this point, all should be done in the board class.
  describe GameEngine do
   before(:each) {@game = GameEngine.new} 
   before(:each) {@white = 0}
   before(:each) {@black = 1}
   describe "#in_check?" do
    it "game has just started, not in check" do
      expect(@game.in_check?(@white)).to be false
      expect(@game.in_check?(@black)).to be false
    end
    it "white knight threatens the black king" do
      @game.make_move("B1", "C7")
      piece = @game.board.piece_at("C", 7)
      expect(piece.position).to eq [6,2]
      expect(@game.board.white_list).to include(piece)
      puts @game
      expect(@game.valid_moves("C7")).to include([7,4])
      expect(@game.in_check?(@black)).to be true
    end
    it "black rook threatens the white king" do
      @game.make_move("A8", "E4")
      @game.make_move("E2", "H3")
      puts @game
      expect(@game.in_check?(@white)).to be true
    end
    it "black rook does not threaten the white king" do
      @game.make_move("A8", "E4")
      puts @game
      expect(@game.in_check?(@white)).to be false
    end
    it "white queen threatens the black king diagonally" do
      @game.make_move("D1", "G6") 
      @game.make_move("F7", "F6")
      puts @game
      expect(@game.in_check?(@black)).to be true
    end
    it "white queen threatens the black king vertically" do
      @game.make_move("D1", "E7") 
      puts @game
      expect(@game.in_check?(@black)).to be true
    end
    it "pawn threatens king" do
      @game.make_move("D2", "D7") 
      puts @game
      expect(@game.in_check?(@black)).to be true
    end
    it "pawnis next to king but does not threaten king" do
      @game.make_move("D2", "E7") 
      puts @game
      expect(@game.in_check?(@black)).to be false
   end
   it "both kings are next to each other, both sides in check" do
    @game.make_move("E1","E7")
    puts @game
    expect(@game.in_check?(@black)).to be true
    expect(@game.in_check?(@white)).to be true
   end
  end
  describe "#king_is_dead?" do
   it "nothing has happened, no king is dead" do
    puts @game
    expect(@game.king_is_dead?(@black)).to be false
    expect(@game.king_is_dead?(@white)).to be false
   end
   it "white king gets taken" do
    @game.make_move("D8", "E1")
    puts @game
    expect(@game.king_is_dead?(@white)).to be true
   end
   it "black king gets taken" do
    @game.make_move("D1", "E8")
    puts @game
    expect(@game.king_is_dead?(@black)).to be true
   end
  end
  describe "#checkmate?" do
   it "the game just started" do
    puts @game
    expect(@game.checkmate?(@white)).to be false
    expect(@game.checkmate?(@black)).to be false
   end
   it "the black king is surrounded by pawns" do
    @game = GameEngine.new
    @game.make_move("F1","D7")
    @game.make_move("C1","F7")
    @game.make_move("D1","E6")
    wk = @game.piece_at("G1")
    expect(@game.valid_moves("G1")).to match_array [[2,5],[2,7]]
    expect(@game.valid_moves("G7")).to match_array [[5,6],[4,6]]
    expect(@game.piece_at("A7")).to be_a Pawn
    expect(@game.piece_at("C8")).to be_a Bishop
    expect(@game.in_check?(@black)).to be true
    expect(@game.checkmate?(@white)).to be false
    expect(@game.checkmate?(@black)).to be true
   end
  end
 end
end
