# frozen_string_literal: true

# Verify the user input in the chess game
module VerifyMovement
  def type_of_move(piece, new_pos)
    if basic_move?(piece, new_pos)
      return 'basic' unless [Rook, Bishop, Queen].include?(piece.class) && leap_over_others?(piece, new_pos)
    elsif special_move?(piece, new_pos)
      return 'Castling' if piece.instance_of?(King)

      return @board.at_square(new_pos) ? 'Pawn capture' : 'En passant'
    end
    'invalid'
  end

  def basic_move?(piece, new_pos)
    piece.next_move.include?(new_pos)
  end

  def special_move?(piece, new_pos)
    return false unless piece.instance_of?(Pawn) || piece.instance_of?(King)

    if piece.instance_of?(Pawn)
      piece.capture_move.include?(new_pos)
    else
      piece.castling_move.include?(new_pos)
    end
  end
end
