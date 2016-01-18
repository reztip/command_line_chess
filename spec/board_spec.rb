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
          b1 = @board.piece_at("B", 1)
          @board.remove_piece("B1",b1)
          l1 = @board.white_list
          l2 = @board.black_list
          expect(@board.piece_at("B", 1)).to be_nil
          d8 = @board.piece_at("D",8)
          expect(@board.piece_at("D", 8)).to eq Queen.new(:black, [7, 3])
          @board.remove_piece("D8", d8)
          expect(@board.piece_at("D", 8)).to be_nil
          expect(l1.length).to eq 15
          expect(l2.length).to eq 15
        end

        it "does not throw an error if the piece is nil" do
                expect(@board.piece_at("D", 4)).to be_nil
           expect {@board.remove_piece("D4",nil)}.not_to raise_error
         end

         it "removes piecs from their appropriate list" do
          b1 = @board.piece_at("B", 1)
          @board.remove_piece("B1",b1)
          expect(@board.white_list).not_to include b1 
          c7 = @board.piece_at("C",7)
          @board.remove_piece("C7",c7)
          expect(@board.black_list).not_to include c7 
        end
      end

    #TODO -all the hard stuff. Like checkng valid moves, checkmate, etc. 
    context '#piece_moves' do
     let(:board) {Board.new}
     context Pawn do
      it "sees bottom left actual possible moves correctly (pawn)" do
        piece = @board.piece_at("A", 2)
        expected_moves = [[2,0], [3,0]]
         potentials = piece.potential_moves()
         expect(@board.piece_moves(piece)).to match_array expected_moves
       end
       it "recognizes if a pawn in the starting position is blocked" do
         @board.move_piece("B2", "A3")
         piece = @board.piece_at("A", 2)
         expected_moves = []
         potentials = piece.potential_moves
         expect(@board.piece_at("A",3)).to eq Pawn.new(:white, [2,0])
         expect(@board.piece_moves(piece)).to match_array expected_moves
       end
       it "same applies for blocked black piece" do
         @board.move_piece("G7", "H6")
         piece = @board.piece_at("H", 7)
         expected_moves = []
         potentials = piece.potential_moves
         expect(@board.piece_at("H",6)).to eq Pawn.new(:black, [5,7])
         expect(@board.piece_moves(piece)).to match_array expected_moves
       end
       it "pawns of different colors block each other" do
         @board.move_piece("G7", "A3")
         piece = @board.piece_at("A", 2 )
         expected_moves = []
         potentials = piece.potential_moves
         expect(@board.piece_at("A",3)).to eq Pawn.new(:black, [2,0])
         expect(@board.piece_moves(piece)).to match_array expected_moves
         @board.move_piece("A2", "A6")
         black = @board.piece_at("A",7)
         expect(@board.piece_moves(black)).to match_array expected_moves
       end
       it "a white pawn can capture a black pawn in  either diagonal" do
         @board.move_piece("C7", "C3")
         @board.move_piece("E7", "E3")
         @board.move_piece("A2", "D3")
         piece = @board.piece_at("D",2) #D2 = [1, 3]
         expected_moves = [ [2,2], [2,4]]
         expect(@board.piece_moves(piece)).to match_array expected_moves
       end
    end
    context Rook do
     it "cant budge initially" do
       white = @board.piece_at("A", 1)
       black = @board.piece_at("A", 8)
       expected_moves = []
       white_moves = white.potential_moves
       black_moves = black.potential_moves
       expect(@board.piece_moves(white)).to match_array expected_moves
       expect(@board.piece_moves(black)).to match_array expected_moves
     end
     it "is unrestricted on an empty board" do
       pos = []
       (0..7).each do |x|
         pos << [x,0] if x != 0
         pos << [0,x] if x != 0
         (0..7).each do |y|
          @board.board[x][y] = nil
         end
       end
       @board.set_piece("A", 1, Rook.new(:white, [0,0]))
       expect(@board.piece_moves(@board.piece_at("A",1))).to match_array pos
     end

     it "has two enemy rooks on either ends" do
       pos = []
       (0..7).each do |x|
         pos << [x,0] if x != 0
         pos << [0,x] if x != 0
         (0..7).each do |y|
          @board.board[x][y] = nil
         end
       end
       @board.set_piece("A", 1, Rook.new(:white, [0,0]))
       @board.set_piece("A", 8, Rook.new(:black, [7,0]))
       @board.set_piece("H", 1, Rook.new(:black, [0,7]))
       expect(@board.piece_moves(@board.piece_at("A",1))).to match_array pos
     end
     it "has all enemy neigbhors" do
     pos = [[4,3], [4,5], [5,4], [3,4]]
     map = {3 => "D", 4 => "E", 5 => "F"}
     rook = Rook.new(:white, [4,4])
     @board.set_piece("E", 5, rook)
     [-1,1].each do |i|
         rk = Rook.new(:black, [4 + i, 4 ])
         @board.set_piece(map[4+i], 5 , rk)
         rk = Rook.new(:black, [4 , 4+i ])
         @board.set_piece("E", 4 + i + 1, rk)
       end
     expect(@board.piece_moves(rook)).to match_array pos
     end
     it "is blocked on one side" do
      @board.set_piece("A", 1, Rook.new(:white, [0,0]))
      rook = @board.piece_at("A",1)
      @board.set_piece("A", 2, nil)
      pos = []
      (1..6).each {|i| pos << [i,0]}
      expect(@board.piece_moves(rook)).to match_array pos
     end
    end
    context Knight do
      it "is in an initial place" do
        knight = @board.piece_at("G",8) #[7,6]
        expected_moves = [[5,7],[5,5]]
        expect(@board.piece_moves(knight)).to match_array expected_moves
      end
      it "can hit six moves in column 3" do
        @board.set_piece("C",3, Knight.new(:black, [4,4]))
        knight = @board.piece_at("C",3)
        expected_moves = [[5,6],[5,2],[3,6],[3,2],[2,5], [2,3]]
        expect(@board.piece_moves(knight)).to match_array expected_moves
      end
    end
    context Bishop do
     it "bishop cannot budge initially" do
      black = @board.piece_at("F", 8)
      white = @board.piece_at("F", 1)
      expect(@board.piece_moves(white)).to match_array []
      expect(@board.piece_moves(black)).to match_array []
     end
     it "has its pawns in its way moved" do
       @board.set_piece("E",2, nil)
       @board.set_piece("G",2, nil)
       pos =  [[2,7], [1,6]]
       (1..5).each {|i| pos << [0+ i, 5 -i]}
       bish = @board.piece_at("F", 1)
       expect(@board.piece_moves(bish)).to match_array pos
     end
     it "has its pawns in its way moved and one enemy pawn in B5" do
       @board.set_piece("E",2, nil)
       @board.set_piece("G",2, nil)
       @board.set_piece("B",5, Pawn.new(:black, [6,1]))
       pos =  [[2,7], [1,6]]
       (1..4).each {|i| pos << [0+ i, 5 -i]}
       bish = @board.piece_at("F", 1)
       expect(@board.piece_moves(bish)).to match_array pos
     end
     it "is surrounded by enemyies everywhere" do
       bish = Bishop.new(:white, [3, 2])
       @board.set_piece("C", 4, bish)
       @board.set_piece("D",3, Pawn.new(:black, [2,3]))
       @board.set_piece("D",5, Pawn.new(:black, [4, 3]))
       @board.set_piece("B",3, Pawn.new(:black, [2, 1]))
       @board.set_piece("B",5,Pawn.new(:black,[4,1]))
       pos = [[2,3], [4,3], [2,1], [4,1]]
       expect(@board.piece_moves(bish)).to match_array pos
     end
    end

   end
   describe "#unmake_move" do
   it "returns board state after moves are made involving a team replacement" do
      from = "A1"
       to = "A2"
        rook = @board.piece_at("A",1)
        pawn = @board.piece_at("A",2)
        whites = @board.white_list
        @board.move_piece(from,to)
        expect(whites.length).to eq 15
        @board.unmake_move(rook,pawn, from, to, :white)
        expect(@board.piece_at("A",1)).to eq Rook.new(:white, [0,0])
        expect(@board.piece_at("A",2)).to eq Pawn.new(:white,[1,0])
        expect(whites.length).to eq 16
    end
    it "returns board state after moves are made involving black taking white" do
      from = "D8"
      to = "D1"
      wq = @board.piece_at("D",1)
      bq = @board.piece_at("D",8)
      whites = @board.white_list
      expect(whites.length).to eq 16
      @board.move_piece(from,to)
      expect(whites.length).to eq 15
      @board.unmake_move(bq,wq,from,to, :black)
      expect(whites.length).to eq 16
      expect(@board.piece_at("D",1)).to eq wq
      expect(@board.piece_at("D",8)).to eq bq
    end
    it "returns board state after moving a piece to an empty slot" do
      from = "G1"
      to = "H3"
      wh = @board.piece_at("G",1)
      @board.move_piece(from, to)
      expect(@board.piece_at("H",3)).to eq wh
      @board.unmake_move(wh, nil, from, to, :white)
      expect(@board.piece_at("H",3)).to be_nil
      expect(@board.piece_at("G",1)).to eq wh
      expect(wh.position).to eq [0,6]
    end
   end
  end
end
