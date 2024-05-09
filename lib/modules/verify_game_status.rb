# frozen_string_literal: true

# Verify the game status in the chess game
module VerifyStatus
  def in_check?(color)
    player = color == 'white' ? @white : @black
    enemy = player == @white ? @black : @white
    king = player.find { |piece| piece.instance_of?(King) }

    enemy.any? do |piece|
      can_capture?(piece, king)
    end
  end

  def will_in_check?(piece, new_pos)
    copy = self.clone
    copy.move_piece(piece, new_pos)
    copy.in_check?(@curr_player)
  end

  def can_capture?(piece, target_piece)
    return false if piece.same_color?(target_piece)

    next_capture_move(piece).include?(target_piece.curr_pos)
  end

  def next_capture_move(piece)
    case piece
    in Rook | Bishop | Queen
      piece.next_move.reject { |new_pos| leap_over_others?(piece, new_pos) }
    in Pawn
      piece.capture_move.select do |new_pos|
        @board.at_square(new_pos) && !piece.same_color?(@board.at_square(new_pos))
      end
    else
      piece.next_move
    end
  end
end
