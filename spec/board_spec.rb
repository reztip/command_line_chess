require_relative './spec_helper.rb'
module Chess
  describe Board do
      before(:each) do
        @board = Board.new
      end
      context "new board" do
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

  it "should give a black rook at position A8" do
    expect(@board.piece_at('A', 8)).to eq Rook.new(:black, [7, 0])
  end
      end
      context '#move_piece' do
        it "has one piece moved frominitial board" do
    expect(@board.piece_at("A",2)).to eq Pawn.new(:white, [1,0])
      @board.move_piece("A2", "A3")    
    expect(@board.piece_at("A",3)).to eq Pawn.new(:white, [2, 0])
  end
  it "recognizes pieces are removed from starting point when moved" do
    expect(@board.piece_at("A",2)).to eq Pawn.new(:white, [1,0])
    @board.move_piece("A2", "A3")
    expect(@board.piece_at("A",2)).to be_nil
    @board.move_piece("A3", "A4")    
    expect(@board.piece_at("A",4)).to eq Pawn.new(:white, [3, 0])
    expect(@board.piece_at("A",3)).to be_nil
  end
      end
    context '#remove_piece' do
        let(:board) {Board.new}
        it "removes pieces properly" do
          expect(@board.piece_at("B", 2)).to eq Pawn.new(:white, [1, 1])
          @board.remove_piece("B1")
          expect(@board.piece_at("B", 1)).to be_nil
          expect(@board.piece_at("D", 8)).to eq Queen.new(:black, [7, 3])
          @board.remove_piece("D8")
          expect(@board.piece_at("D", 8)).to be_nil
        end

        it "does not throw an error if the piece is nil" do
                expect(@board.piece_at("D", 4)).to be_nil
           expect {@board.remove_piece("D4")}.not_to raise_error
         end

         it "removes piecs from their appropriate list" do
          @board.remove_piece("B1")
          expect(@board.white_list).not_to include Knight.new(:white, [0,1])
          @board.remove_piece("C7")
          expect(@board.black_list).not_to include Pawn.new(:black, [6, 2])
        end
      end

    #TODO -all the hard stuff. Like checkng valid moves, checkmate, etc. 
    context '#actual_possible_moves' do
     let(:board) {Board.new}
     context Pawn do
      it "sees bottom left actual possible moves correctly (pawn)" do
        piece = @board.piece_at("A", 2)
        expected_moves = [[2,0], [3,0]]
         potentials = piece.potential_moves()
         expect(@board.actual_possible_moves(piece,potentials)).to match_array expected_moves
       end
       it "recognizes if a pawn in the starting position is blocked" do
         @board.move_piece("B2", "A3")
         piece = @board.piece_at("A", 2)
         expected_moves = []
         potentials = piece.potential_moves
         expect(@board.piece_at("A",3)).to eq Pawn.new(:white, [2,0])
         expect(@board.actual_possible_moves(piece, potentials)).to match_array expected_moves
       end
       it "same applies for blocked black piece" do
         @board.move_piece("G7", "H6")
         piece = @board.piece_at("H", 7)
         expected_moves = []
         potentials = piece.potential_moves
         expect(@board.piece_at("H",6)).to eq Pawn.new(:black, [5,7])
         expect(@board.actual_possible_moves(piece, potentials)).to match_array expected_moves
       end
       it "pawns of different colors block each other" do
         @board.move_piece("G7", "A3")
         piece = @board.piece_at("A", 2 )
         expected_moves = []
         potentials = piece.potential_moves
         expect(@board.piece_at("A",3)).to eq Pawn.new(:black, [2,0])
         expect(@board.actual_possible_moves(piece, potentials)).to match_array expected_moves
         @board.move_piece("A2", "A6")
         black = @board.piece_at("A",7)
         expect(@board.actual_possible_moves(black, black.potential_moves)).to match_array expected_moves
       end
       it "a white pawn can capture a black pawn in  either diagonal" do
         @board.move_piece("C7", "C3")
         @board.move_piece("E7", "E3")
         @board.move_piece("A2", "D3")
         piece = @board.piece_at("D",2) #D2 = [1, 3]
         expected_moves = [ [2,2], [2,4]]
         expect(@board.actual_possible_moves(piece, piece.potential_moves)).to match_array expected_moves
         puts @board.to_s
       end
    end
    context Rook do
     it "cant budge initially" do
       white = @board.piece_at("A", 1)
       black = @board.piece_at("A", 8)
       expected_moves = []
       white_moves = white.potential_moves
       black_moves = black.potential_moves
       expect(@board.actual_possible_moves(white, white_moves)).to match_array expected_moves
       expect(@board.actual_possible_moves(black, black_moves)).to match_array expected_moves
     end
    end
   end
  end
end
