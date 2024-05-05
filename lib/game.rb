# frozen_string_literal: true

require_relative './board'
require_relative './modules/piece_setup'

# A command line Chess game where two players can play against each other.
class ChessGame
  include PieceSetup

  def initialize
    @board = ChessBoard.new
    @white = []
    @black = []
    @curr_player = 'white'
    @last_move

    set_initial_pieces
  end
end
