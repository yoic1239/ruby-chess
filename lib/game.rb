# frozen_string_literal: true

require_relative './board'
require_relative './modules/piece_setup'
require_relative './modules/verify_input'
require_relative './modules/moving_rules'
require_relative './modules/verify_movement'
require_relative './modules/verify_game_status'

# A command line Chess game where two players can play against each other.
class ChessGame
  include PieceSetup
  include VerifyInput
  include MovingRules
  include VerifyMovement
  include VerifyStatus

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

  def change_player
    @curr_player = @curr_player == 'white' ? 'black' : 'white'
  end

  def game_over?
    mate?(@curr_player) || stalemate?(@curr_player)
  end

  def introduction
    puts <<~HEREDOC
      Welcome to the Chess Game!

      Type the position of the piece you want to move, and then new position for the piece.
      i.e. Type 'a2 a3' to move the piece from a2 to a3

      Let's start!
    HEREDOC
  end

  # rubocop: disable Metrics/MethodLength
  # rubocop: disable Layout/LineLength
  def print_error_message(situation, *new_pos)
    case situation
    when 'wrong format'
      puts "\e[0;31mIncorrect input format!\e[0m Correct format: \e[0;32m<Position of piece to be moved> <New position>\e[0m"

    when 'move wrong piece'
      puts "\e[0;31mYou are not moving your piece.\e[0m Correct format: \e[0;32m<Position of piece to be moved> <New position>\e[0m"

    when 'invalid new position'
      puts "\e[0;31mInvalid move.\e[0m Cannot move the piece to #{new_pos.capitalize}\e[0m"

    when 'illegal move'
      puts "\e[0;31mIllegal move!.\e[0m The move will make you in check."
    end

    puts 'Please try again.'
  end
  # rubocop: enable Metrics/MethodLength
  # rubocop: enable Layout/LineLength
end
