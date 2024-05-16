# frozen_string_literal: true

# Verify the user input in the chess game
module VerifyMovement
  def valid_move?(user_input)
    piece = @board.at_square(user_input[0])
    new_pos = user_input[1]
    (type_of_move(piece, new_pos) != 'Invalid' || print_error_message('invalid new position', new_pos)) &&
      (!will_in_check?(piece, new_pos) || print_error_message('illegal move'))
  end

  def type_of_move(piece, new_pos)
    if basic_move?(piece, new_pos)
      return 'Basic'
    elsif special_move?(piece, new_pos)
      return 'Castling' if piece.instance_of?(King)

      return @board.at_square(new_pos) ? 'Pawn capture' : 'En passant'
    end

    'Invalid'
  end

  def basic_move?(piece, new_pos)
    if [Rook, Bishop, Queen].include?(piece.class)
      piece.next_move.include?(new_pos) && !leap_over_others?(piece, new_pos)
    else
      piece.next_move.include?(new_pos)
    end
  end

  def special_move?(piece, new_pos)
    return false unless piece.instance_of?(Pawn) || piece.instance_of?(King)

    if piece.instance_of?(Pawn)
      valid_pawn_capture?(piece, new_pos)
    else
      valid_castling?(piece, new_pos)
    end
  end

  def valid_pawn_capture?(pawn, new_pos)
    return false unless pawn.capture_move.include?(new_pos)

    if @board.at_square(new_pos)
      true
    else
      allow_en_passant?(pawn, new_pos)
    end
  end

  def valid_castling?(king, new_pos)
    rook_pos = new_pos[0] == 'c' ? "a#{new_pos[1]}" : "h#{new_pos[1]}"
    rook = @board.at_square(rook_pos)

    return false unless rook.instance_of?(Rook)

    meet_castling_conditions?(king, rook)
  end
end
