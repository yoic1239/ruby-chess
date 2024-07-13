# frozen_string_literal: true

require_relative '../lib/game'

describe ChessGame do
  describe '#player_input' do
    subject(:game_player_input) { described_class.new }

    context 'when the use input is a valid and the move is valid' do
      before do
        valid_input = 'a2 a3'
        allow(game_player_input).to receive(:gets).and_return(valid_input)
        allow(game_player_input).to receive(:valid_input?).and_return(true)
        allow(game_player_input).to receive(:valid_move?).and_return(true)
      end

      it 'stops the loop and calls the gets method only once' do
        expect(game_player_input).to receive(:gets).once
        game_player_input.player_input
      end

      it 'returns the last user input' do
        result = game_player_input.player_input
        expect(result).to eq(%w[a2 a3])
      end
    end

    context 'when the user input is invalid, then valid and the move is also valid' do
      before do
        invalid_input = 'a2a3'
        valid_input = 'a2 a3'
        allow(game_player_input).to receive(:gets).and_return(invalid_input, valid_input)
        allow(game_player_input).to receive(:valid_input?).and_return(false, true)
        allow(game_player_input).to receive(:valid_move?).and_return(true)
      end

      it 'stops the loop and calls the gets method twice' do
        expect(game_player_input).to receive(:gets).twice
        game_player_input.player_input
      end

      it 'returns the last user input' do
        result = game_player_input.player_input
        expect(result).to eq(%w[a2 a3])
      end
    end

    context 'when the user input is valid, but the move is invalid, and then valid' do
      before do
        invalid_move = 'a2 a7'
        valid_move = 'a2 a4'
        allow(game_player_input).to receive(:gets).and_return(invalid_move, valid_move)
        allow(game_player_input).to receive(:valid_input?).and_return(true)
        allow(game_player_input).to receive(:valid_move?).and_return(false, true)
      end

      it 'stops the loop and calls the gets method twice' do
        expect(game_player_input).to receive(:gets).twice
        game_player_input.player_input
      end

      it 'returns the last user input' do
        result = game_player_input.player_input
        expect(result).to eq(%w[a2 a4])
      end
    end
  end

  describe '#change_player' do
    let(:board_change_player) { instance_double(ChessBoard) }

    context 'when the current player is white' do
      subject(:game_player_white) { described_class.new(board_change_player, 'white') }

      before do
        allow(board_change_player).to receive(:place_piece)
      end

      it 'changes the current player to black' do
        expect { game_player_white.change_player }.to change { game_player_white.instance_variable_get(:@curr_player) }.from('white').to('black')
      end
    end

    context 'when the current player is black' do
      subject(:game_player_black) { described_class.new(board_change_player, 'black') }

      before do
        allow(board_change_player).to receive(:place_piece)
      end

      it 'changes the current player to white' do
        expect { game_player_black.change_player }.to change { game_player_black.instance_variable_get(:@curr_player) }.from('black').to('white')
      end
    end
  end
end
