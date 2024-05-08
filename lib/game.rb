# frozen_string_literal: true

require_relative './board'
require_relative './modules/piece_setup'
require_relative './modules/verify_input'
require_relative './modules/moving_rules'
require_relative './modules/verify_movement'

# A command line Chess game where two players can play against each other.
class ChessGame
  include PieceSetup
  include VerifyInput
  include MovingRules
  include VerifyMovement

  def initialize
    @board = ChessBoard.new
    @white = []
    @black = []
    @curr_player = 'white'

    set_initial_pieces
  end

  def player_input
    loop do
      puts "Current Player: #{@curr_player.capitalize}"
      puts "Enter the square of the piece to be moved, and which square to move to. e.g. 'a2 a3'"
      user_input = gets.chomp.downcase.split
      return user_input if valid_input?(user_input) && valid_move?(user_input)
    end
  end

  def move_piece(piece, new_pos)
    @board.place_piece(nil, piece.curr_pos)
    @board.place_piece(piece, new_pos)
    piece.move_to(new_pos)
    @last_move = piece
  end

  # rubocop: disable Metrics/MethodLength
  def print_error_message(situation)
    case situation
    when 'wrong format'
      puts <<~HEREDOC
        \e[0;31mIncorrect input format!\e[0m Correct format: \e[0;32m<Position of piece to be moved> <New position>\e[0m
        i.e. Type '\e[0;32ma2 a3\e[0m' to move the piece from a2 to a3\e[0m
      HEREDOC

    when 'move wrong piece'
      puts <<~HEREDOC
        \e[0;31mYou are not moving your piece.\e[0m Correct format: \e[0;32m<Position of piece to be moved> <New position>\e[0m
        i.e. Type '\e[0;32ma2 a3\e[0m' to move the piece from a2 to a3\e[0m
      HEREDOC

    when 'invalid new position'
      puts <<~HEREDOC
        \e[0;31mCannot move the piece to a square containing your own piece.\e[0m Correct format: \e[0;32m<Position of piece to be moved> <New position>\e[0m
        i.e. Type '\e[0;32ma2 a3\e[0m' to move the piece from a2 to a3\e[0m
      HEREDOC

    when 'illegal move'
      puts <<~HEREDOC
        \e[0;31mIllegal move!.\e[0m The move will make you in check.
      HEREDOC
    end
  end
  # rubocop: enable Metrics/MethodLength
end
