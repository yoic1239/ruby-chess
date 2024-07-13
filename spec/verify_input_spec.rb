# frozen_string_literal: true

require_relative '../lib/game'

describe ChessGame do
  let(:board_input) { instance_double(ChessBoard) }

  describe '#valid_input?' do
    subject(:game_input) { described_class.new }

    context 'when the user input is not in correct format' do
      before do
        allow(game_input).to receive(:correct_format?).and_return(false)
        allow(game_input).to receive(:print_error_message)
      end

      it 'prints error message' do
        invalid_input = ['a2']

        expect(game_input).to receive(:print_error_message).with('wrong format').once
        game_input.valid_input?(invalid_input)
      end

      it 'is not a valid input' do
        invalid_input = ['a2']
        result = game_input.valid_input?(invalid_input)
        expect(result).to be false
      end
    end

    context 'when the user input is in correct format but not moving self piece' do
      before do
        allow(game_input).to receive(:correct_format?).and_return(true)
        allow(game_input).to receive(:move_self_piece?).and_return(false)
        allow(game_input).to receive(:print_error_message)
      end

      it 'prints error message' do
        input_not_self_piece = %w[a7 a6]

        expect(game_input).to receive(:print_error_message).with('move wrong piece').once
        game_input.valid_input?(input_not_self_piece)
      end

      it 'is not a valid input' do
        input_not_self_piece = %w[a7 a6]
        result = game_input.valid_input?(input_not_self_piece)
        expect(result).to be false
      end
    end

    context 'when the user input is in correct format and is moving self piece, but the new position is invalid' do
      before do
        allow(game_input).to receive(:correct_format?).and_return(true)
        allow(game_input).to receive(:move_self_piece?).and_return(true)
        allow(game_input).to receive(:valid_new_position?).and_return(false)
        allow(game_input).to receive(:print_error_message)
      end

      it 'prints error message' do
        invalid_new_position = %w[a1 a2]

        expect(game_input).to receive(:print_error_message).with('invalid new position', invalid_new_position[1]).once
        game_input.valid_input?(invalid_new_position)
      end

      it 'is not a valid input' do
        invalid_new_position = %w[a1 a2]
        result = game_input.valid_input?(invalid_new_position)
        expect(result).to be false
      end
    end

    context 'when the user input is in correct format, the player is moving self piece, and the new position is invalid' do
      before do
        allow(game_input).to receive(:correct_format?).and_return(true)
        allow(game_input).to receive(:move_self_piece?).and_return(true)
        allow(game_input).to receive(:valid_new_position?).and_return(true)
        allow(game_input).to receive(:print_error_message)
      end

      it 'does not print any error message' do
        valid_input = %w[a2 a3]
        expect(game_input).not_to receive(:print_error_message)
        game_input.valid_input?(valid_input)
      end

      it 'is a valid input' do
        valid_input = %w[a2 a3]
        result = game_input.valid_input?(valid_input)
        expect(result).to be true
      end
    end
  end

  describe '#correct_format?' do
    subject(:game_format) { described_class.new }

    context 'when user input are 2 valid positions in chess board' do
      it 'is correct format' do
        valid_input = %w[a3 h8]
        result = game_format.correct_format?(valid_input)
        expect(result).to be true
      end
    end

    context 'when user input more than 2 positions' do
      it 'is not in correct format' do
        three_positions = %w[a1 a2 a3]
        result = game_format.correct_format?(three_positions)
        expect(result).to be false
      end
    end

    context 'when either the inputted position is not a valid position in chess board' do
      it 'is not in correct format' do
        invalid_position = %w[a9 a10]
        result = game_format.correct_format?(invalid_position)
        expect(result).to be false
      end
    end
  end

  describe '#move_self_piece?' do
    subject(:game_self_piece) { described_class.new(board_input, 'white') }

    context 'when the first inputted position does not contain any piece' do
      before do
        allow(board_input).to receive(:place_piece)
        allow(board_input).to receive(:at_square).and_return(nil)
      end

      it 'is not moving self piece' do
        input_no_piece = %w[a3 a4]
        result = game_self_piece.move_self_piece?(input_no_piece)
        expect(result).to be false
      end
    end

    context "when the first inputted position contains the enemy's piece" do
      before do
        enemy_pawn = Pawn.new('black', 'a4')
        allow(board_input).to receive(:place_piece)
        allow(board_input).to receive(:at_square).and_return(enemy_pawn)
      end

      it 'is not moving self piece' do
        input_enemy_piece = %w[a4 a5]
        result = game_self_piece.move_self_piece?(input_enemy_piece)
        expect(result).to be false
      end
    end

    context "when the first inputted position contains the current player's piece" do
      before do
        self_pawn = Pawn.new('white', 'a2')
        allow(board_input).to receive(:place_piece)
        allow(board_input).to receive(:at_square).and_return(self_pawn)
      end

      it 'is moving self piece' do
        input_self_piece = %w[a2 a4]
        result = game_self_piece.move_self_piece?(input_self_piece)
        expect(result).to be true
      end
    end
  end

  describe '#valid_new_position?' do
    subject(:game_new_position) { described_class.new(board_input, 'white') }

    context "when the second inputted position contains the current player's piece" do
      before do
        self_pawn = Pawn.new('white', 'c3')
        allow(board_input).to receive(:place_piece)
        allow(board_input).to receive(:at_square).and_return(self_pawn)
      end

      it 'is not a valid new position' do
        input_self_piece = %w[b1 c3]
        result = game_new_position.valid_new_position?(input_self_piece)
        expect(result).to be false
      end
    end

    context 'when the second inputted position does not contain any piece' do
      before do
        allow(board_input).to receive(:place_piece)
        allow(board_input).to receive(:at_square).and_return(nil)
      end

      it 'is a valid new position' do
        input_no_piece = %w[b1 c3]
        result = game_new_position.valid_new_position?(input_no_piece)
        expect(result).to be true
      end
    end

    context "when the second inputted position contains the enemy's piece" do
      before do
        enemy_pawn = Pawn.new('black', 'c3')
        allow(board_input).to receive(:place_piece)
        allow(board_input).to receive(:at_square).and_return(enemy_pawn)
      end

      it 'is a valid new position' do
        input_enemy_piece = %w[b1 c3]
        result = game_new_position.valid_new_position?(input_enemy_piece)
        expect(result).to be true
      end
    end
  end
end
