# frozen_string_literal: true

require_relative '../lib/game'

describe ChessGame do
  describe '#valid_move?' do
    subject(:game_valid_move) { described_class.new(board_valid_move) }
    let(:board_valid_move) { instance_double(ChessBoard) }

    before do
      allow(board_valid_move).to receive(:place_piece)
    end

    context 'when type of the move is invaild' do
      before do
        allow(board_valid_move).to receive(:at_square)
        allow(game_valid_move).to receive(:type_of_move).and_return('Invalid')
        allow(game_valid_move).to receive(:print_error_message)
      end

      it 'prints error message' do
        user_input = %w[a1 b2]
        new_pos = user_input[1]
        expect(game_valid_move).to receive(:print_error_message).with('invalid new position', new_pos)

        game_valid_move.valid_move?(user_input)
      end

      it 'is not a valid move' do
        user_input = %w[a1 b2]
        result = game_valid_move.valid_move?(user_input)

        expect(result).to be_falsey
      end
    end

    context 'when type of the move is not invaild and the move will make the player in check' do
      before do
        allow(board_valid_move).to receive(:at_square)
        allow(game_valid_move).to receive(:type_of_move).and_return('Basic')
        allow(game_valid_move).to receive(:will_in_check?).and_return(true)
        allow(game_valid_move).to receive(:print_error_message)
      end

      it 'print error message' do
        user_input = %w[a1 a2]
        expect(game_valid_move).to receive(:print_error_message).with('illegal move')

        game_valid_move.valid_move?(user_input)
      end

      it 'is not a valid move' do
        user_input = %w[a1 a2]
        result = game_valid_move.valid_move?(user_input)

        expect(result).to be_falsey
      end
    end

    context 'when type of the move is not invaild and the move will not make the player in check' do
      before do
        allow(board_valid_move).to receive(:at_square)
        allow(game_valid_move).to receive(:type_of_move).and_return('Basic')
        allow(game_valid_move).to receive(:will_in_check?).and_return(false)
      end

      it 'does not print any error message' do
        user_input = %w[a1 a2]
        expect(game_valid_move).not_to receive(:print_error_message)

        game_valid_move.valid_move?(user_input)
      end

      it 'is a valid move' do
        user_input = %w[a1 a2]
        result = game_valid_move.valid_move?(user_input)

        expect(result).to be true
      end
    end
  end

  describe '#type_of_move' do
    subject(:game_move_type) { described_class.new(board_move_type) }
    let(:board_move_type) { instance_double(ChessBoard) }

    before do
      allow(board_move_type).to receive(:place_piece)
    end

    context 'when the move is neither basic move nor special move' do
      before do
        allow(game_move_type).to receive(:basic_move?).and_return(false)
        allow(game_move_type).to receive(:special_move?).and_return(false)
      end

      it 'returns Invalid' do
        pawn = Pawn.new('white', 'c2')
        invalid_new_pos = 'c5'
        type = game_move_type.type_of_move(pawn, invalid_new_pos)

        expect(type).to eq('Invalid')
      end
    end

    context 'when the move is basic move' do
      before do
        allow(game_move_type).to receive(:basic_move?).and_return(true)
      end

      it 'returns Basic' do
        knight = Knight.new('white', 'b1')
        new_pos = 'c3'
        type = game_move_type.type_of_move(knight, new_pos)

        expect(type).to eq('Basic')
      end
    end

    context 'when the move is special move' do
      context 'when the piece is King' do
        before do
          allow(game_move_type).to receive(:basic_move?).and_return(false)
          allow(game_move_type).to receive(:special_move?).and_return(true)
        end

        it 'returns Castling' do
          king = King.new('white', 'e1')
          new_pos = 'g1'
          type = game_move_type.type_of_move(king, new_pos)

          expect(type).to eq('Castling')
        end
      end

      context 'when the piece is Pawn and there is other piece at the new position' do
        before do
          allow(game_move_type).to receive(:basic_move?).and_return(false)
          allow(game_move_type).to receive(:special_move?).and_return(true)
          allow(board_move_type).to receive(:at_square).and_return(true)
        end

        it 'returns Pawn capture' do
          pawn = Pawn.new('white', 'd2')
          new_pos_capture = 'c3'
          type = game_move_type.type_of_move(pawn, new_pos_capture)

          expect(type).to eq('Pawn capture')
        end
      end

      context 'when the piece is Pawn and there is no other piece at the new position' do
        before do
          allow(game_move_type).to receive(:basic_move?).and_return(false)
          allow(game_move_type).to receive(:special_move?).and_return(true)
          allow(board_move_type).to receive(:at_square).and_return(false)
        end

        it 'returns En passant' do
          pawn = Pawn.new('white', 'd2')
          new_pos_capture = 'c3'
          type = game_move_type.type_of_move(pawn, new_pos_capture)

          expect(type).to eq('En passant')
        end
      end
    end
  end

  describe '#basic_move?' do
    subject(:game_basic_move) { described_class.new }

    context 'when the piece is Rook' do
      let(:rook_basic) { Rook.new('white', 'a1') }

      context "when the piece's next move does not include the new position" do
        it 'is not a valid basic move' do
          invalid_new_pos = 'b2'
          result = game_basic_move.basic_move?(rook_basic, invalid_new_pos)
          expect(result).to be false
        end
      end

      context "when the piece's next move includes the new position, but the piece will jump over other pieces" do
        before do
          allow(game_basic_move).to receive(:leap_over_others?).and_return(true)
        end

        it 'is not a valid basic move' do
          valid_new_position = 'a5'
          result = game_basic_move.basic_move?(rook_basic, valid_new_position)
          expect(result).to be false
        end
      end

      context "when the piece's next move includes the new position, and the piece will not jump over other pieces" do
        before do
          allow(game_basic_move).to receive(:leap_over_others?).and_return(false)
        end

        it 'is a valid basic move' do
          valid_new_position = 'a7'
          result = game_basic_move.basic_move?(rook_basic, valid_new_position)
          expect(result).to be true
        end
      end
    end

    context 'when the piece is Bishop' do
      let(:bishop_basic) { Bishop.new('white', 'c1') }

      context "when the piece's next move does not include the new position" do
        it 'is not a valid basic move' do
          invalid_new_pos = 'a1'
          result = game_basic_move.basic_move?(bishop_basic, invalid_new_pos)
          expect(result).to be false
        end
      end

      context "when the piece's next move includes the new position, but the piece will jump over other pieces" do
        before do
          allow(game_basic_move).to receive(:leap_over_others?).and_return(true)
        end

        it 'is not a valid basic move' do
          valid_new_position = 'a3'
          result = game_basic_move.basic_move?(bishop_basic, valid_new_position)
          expect(result).to be false
        end
      end

      context "when the piece's next move includes the new position, and the piece will not jump over other pieces" do
        before do
          allow(game_basic_move).to receive(:leap_over_others?).and_return(false)
        end

        it 'is a valid basic move' do
          valid_new_position = 'f4'
          result = game_basic_move.basic_move?(bishop_basic, valid_new_position)
          expect(result).to be true
        end
      end
    end

    context 'when the piece is Queen' do
      let(:queen_basic) { Queen.new('white', 'd1') }

      context "when the piece's next move does not include the new position" do
        it 'is not a valid basic move' do
          invalid_new_pos = 'b2'
          result = game_basic_move.basic_move?(queen_basic, invalid_new_pos)
          expect(result).to be false
        end
      end

      context "when the piece's next move includes the new position, but the piece will jump over other pieces" do
        before do
          allow(game_basic_move).to receive(:leap_over_others?).and_return(true)
        end

        it 'is not a valid basic move' do
          valid_new_position = 'b3'
          result = game_basic_move.basic_move?(queen_basic, valid_new_position)
          expect(result).to be false
        end
      end

      context "when the piece's next move includes the new position, and the piece will not jump over other pieces" do
        before do
          allow(game_basic_move).to receive(:leap_over_others?).and_return(false)
        end

        it 'is a valid basic move' do
          valid_new_position = 'd7'
          result = game_basic_move.basic_move?(queen_basic, valid_new_position)
          expect(result).to be true
        end
      end
    end

    context 'when the piece is Pawn' do
      let(:pawn_basic) { Pawn.new('white', 'b2') }

      context "when the piece's next move does not include the new position" do
        it 'is not a valid basic move' do
          invalid_new_pos = 'a3'
          result = game_basic_move.basic_move?(pawn_basic, invalid_new_pos)
          expect(result).to be false
        end
      end

      context "when the piece's next move includes the new position" do
        it 'is a valid basic move' do
          valid_new_pos = 'b3'
          result = game_basic_move.basic_move?(pawn_basic, valid_new_pos)
          expect(result).to be true
        end
      end
    end

    context 'when the piece is Knight' do
      let(:knight_basic) { Knight.new('white', 'b1') }

      context "when the piece's next move does not include the new position" do
        it 'is not a valid basic move' do
          invalid_new_pos = 'c2'
          result = game_basic_move.basic_move?(knight_basic, invalid_new_pos)
          expect(result).to be false
        end
      end

      context "when the piece's next move includes the new position" do
        it 'is a valid basic move' do
          valid_new_pos = 'c3'
          result = game_basic_move.basic_move?(knight_basic, valid_new_pos)
          expect(result).to be true
        end
      end
    end

    context 'when the piece is King' do
      let(:king_basic) { King.new('white', 'e1') }

      context "when the piece's next move does not include the new position" do
        it 'is not a valid basic move' do
          invalid_new_pos = 'c2'
          result = game_basic_move.basic_move?(king_basic, invalid_new_pos)
          expect(result).to be false
        end
      end

      context "when the piece's next move includes the new position" do
        it 'is a valid basic move' do
          valid_new_pos = 'd2'
          result = game_basic_move.basic_move?(king_basic, valid_new_pos)
          expect(result).to be true
        end
      end
    end
  end

  describe '#special_move?' do
    subject(:game_special_move) { described_class.new }

    context 'when the piece is neither Pawn nor King' do
      it 'is not a special move' do
        knight = Knight.new('white', 'b1')
        new_pos = 'c3'
        result = game_special_move.special_move?(knight, new_pos)

        expect(result).to be false
      end
    end

    context 'when the piece is Pawn' do
      context 'when the move is not a valid Pawn capturing move' do
        before do
          allow(game_special_move).to receive(:valid_pawn_capture?).and_return(false)
        end

        it 'is not a special move' do
          pawn = Pawn.new('white', 'b1')
          new_pos_forward = 'b2'
          result = game_special_move.special_move?(pawn, new_pos_forward)

          expect(result).to be false
        end
      end

      context 'when the move is a valid Pawn capturing move' do
        before do
          allow(game_special_move).to receive(:valid_pawn_capture?).and_return(true)
        end

        it 'is a special move' do
          pawn = Pawn.new('white', 'b1')
          new_pos_capture = 'c2'
          result = game_special_move.special_move?(pawn, new_pos_capture)

          expect(result).to be true
        end
      end
    end

    context 'when the piece is King' do
      context 'when the move is not a valid castling' do
        before do
          allow(game_special_move).to receive(:valid_castling?).and_return(false)
        end

        it 'is not a special move' do
          king = King.new('white', 'e1')
          new_pos_forward = 'e2'
          result = game_special_move.special_move?(king, new_pos_forward)

          expect(result).to be false
        end
      end

      context 'when the move is a valid castling' do
        before do
          allow(game_special_move).to receive(:valid_castling?).and_return(true)
        end

        it 'is a special move' do
          king = King.new('white', 'e1')
          new_pos_castling = 'g1'
          result = game_special_move.special_move?(king, new_pos_castling)

          expect(result).to be true
        end
      end
    end
  end

  describe '#valid_pawn_capture?' do
    subject(:game_pawn_capture) { described_class.new(board_pawn_capture) }
    let(:board_pawn_capture) { instance_double(ChessBoard) }

    before do
      allow(board_pawn_capture).to receive(:place_piece)
    end

    context "when the pawn's capture move does not include the new position" do
      it 'is not a valid pawn capturing move' do
        pawn = Pawn.new('white', 'c2')
        invalid_new_pos = 'b4'
        result = game_pawn_capture.valid_pawn_capture?(pawn, invalid_new_pos)

        expect(result).to be false
      end
    end

    context "when the pawn's capture move includes the new position" do
      context 'when there is no other piece at the new position and it is not en passant' do
        before do
          allow(board_pawn_capture).to receive(:at_square).and_return(false)
          allow(game_pawn_capture).to receive(:allow_en_passant?).and_return(false)
        end

        it 'is not a valid pawn capturing move' do
          pawn = Pawn.new('white', 'c2')
          capture_new_pos = 'b3'
          result = game_pawn_capture.valid_pawn_capture?(pawn, capture_new_pos)

          expect(result).to be false
        end
      end

      context 'when there is no other piece at the new position and it is en passant' do
        before do
          allow(board_pawn_capture).to receive(:at_square).and_return(false)
          allow(game_pawn_capture).to receive(:allow_en_passant?).and_return(true)
        end

        it 'is a valid pawn capturing move' do
          pawn = Pawn.new('white', 'c2')
          capture_new_pos = 'b3'
          result = game_pawn_capture.valid_pawn_capture?(pawn, capture_new_pos)

          expect(result).to be true
        end
      end

      context 'when there is other piece at the new position' do
        before do
          allow(board_pawn_capture).to receive(:at_square).and_return(true)
        end

        it 'is a valid pawn capturing move' do
          pawn = Pawn.new('white', 'c2')
          capture_new_pos = 'b3'
          result = game_pawn_capture.valid_pawn_capture?(pawn, capture_new_pos)

          expect(result).to be true
        end
      end
    end
  end

  describe '#valid_castling?' do
    subject(:game_valid_castling) { described_class.new(board_valid_castling) }
    let(:board_valid_castling) { instance_double(ChessBoard) }

    before do
      allow(board_valid_castling).to receive(:place_piece)
    end

    context 'when the rook is not in the castling position' do
      before do
        bishop = Bishop.new('white', 'h1')
        allow(board_valid_castling).to receive(:at_square).and_return(bishop)
      end

      it 'is not valid castling move' do
        king = King.new('white', 'e1')
        short_castling_pos = 'g1'
        result = game_valid_castling.valid_castling?(king, short_castling_pos)

        expect(result).to be false
      end
    end

    context 'when the rook is in the castling position' do
      context 'when the castling conditions are not fulfilled' do
        before do
          rook = Rook.new('white', 'a1')
          allow(board_valid_castling).to receive(:at_square).and_return(rook)
          allow(game_valid_castling).to receive(:meet_castling_conditions?).and_return(false)
        end

        it 'is not valid castling move' do
          king = King.new('white', 'e1')
          long_castling_pos = 'c1'
          result = game_valid_castling.valid_castling?(king, long_castling_pos)

          expect(result).to be false
        end
      end

      context 'when all castling conditions are fulfilled' do
        before do
          rook = Rook.new('white', 'h1')
          allow(board_valid_castling).to receive(:at_square).and_return(rook)
          allow(game_valid_castling).to receive(:meet_castling_conditions?).and_return(true)
        end

        it 'is valid castling move' do
          king = King.new('white', 'e1')
          short_castling_pos = 'g1'
          result = game_valid_castling.valid_castling?(king, short_castling_pos)

          expect(result).to be true
        end
      end
    end
  end
end
