# frozen_string_literal: true

# Verify the user input in the chess game
module VerifyInput
  def valid_input?(user_input)
    return false unless correct_format?(user_input) || print_error_message('wrong format')

    return false unless move_self_piece?(user_input) || print_error_message('move wrong piece')

    return false unless valid_new_position?(user_input) || print_error_message('invalid new position')

    true
  end

  def correct_format?(user_input)
    user_input.all? do |position|
      position.length == 2 && position[0].between?('a', 'h') && position[1].between?('1', '8')
    end && user_input.length == 2
  end

  def move_self_piece?(user_input)
    piece_to_move = @board.at_square(user_input[0])
    !piece_to_move.nil? && piece_to_move.color == @curr_player
  end

  def valid_new_position?(user_input)
    new_square = @board.at_square(user_input[1])
    new_square.nil? || new_square.color != @curr_player
  end
end
