# frozen_string_literal: true

# A command line Chess game where two players can play against each other.
class ChessGame
  def initialize
    @board = ChessBoard.new
    @white = []
    @black = []
    @curr_player = 'white'
  end
end
