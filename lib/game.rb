# frozen_string_literal: true

require_relative './board'
require_relative './modules/piece_setup'
require_relative './modules/verify_input'
require_relative './modules/moving_rules'
require_relative './modules/verify_movement'
require_relative './modules/verify_game_status'
require_relative './modules/move_pieces'
require_relative './modules/save_game'

# A command line Chess game where two players can play against each other.
class ChessGame
  include PieceSetup
  include VerifyInput
  include MovingRules
  include VerifyMovement
  include VerifyStatus
  include MovePieces
  include SaveGame

  def initialize(board = ChessBoard.new, player = 'white')
    if incompleted_games? && to_load_saved_game?
      load_saved_game
    else
      start_new_game(board, player)
    end
  end

  def start_new_game(board, player)
    @board = board
    @white = []
    @black = []
    @curr_player = player

    set_initial_pieces
  end

  # rubocop: disable Metrics/MethodLength
  def play
    introduction
    loop do
      @board.display
      org_pos, new_pos = player_input

      return if @saved

      piece = @board.at_square(org_pos)
      move_piece(piece, new_pos)
      promotion(piece) if piece.instance_of?(Pawn) && piece.can_promote?
      change_player
      break if game_over?
    end
    show_result
    File.delete(@load_file) if @load_file
  end
  # rubocop: enable Metrics/MethodLength

  def player_input
    loop do
      puts "Current Player: #{@curr_player.capitalize}"
      puts "Enter the square of the piece to be moved, and which square to move to. e.g. 'a2 a3'"
      puts "(You can type 'save' to save the game at any time)"
      user_input = gets.chomp.downcase.split

      save_game && return if user_input == ['save']
      return user_input if valid_input?(user_input) && valid_move?(user_input)
    end
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

  def show_result
    if mate?(@curr_player)
      winner = @curr_player == 'white' ? 'Black' : 'White'
      puts "Game over! #{winner} wins the game!"
    else
      puts 'Game over! Draw! You two plays a good game.'
    end
  end

  # rubocop: disable Metrics/MethodLength
  # rubocop: disable Layout/LineLength
  def print_error_message(situation, new_pos = nil)
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

    puts "Please try again.\n"
  end
  # rubocop: enable Metrics/MethodLength
  # rubocop: enable Layout/LineLength
end
