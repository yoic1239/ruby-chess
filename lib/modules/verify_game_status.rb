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

    target_pos = target_piece.curr_pos

    case piece
    in Rook | Bishop | Queen
      piece.next_move.include?(target_pos) && !leap_over_others?(piece, target_pos)
    in Pawn
      piece.capture_move.include?(target_pos)
    else
      piece.next_move.include?(target_pos)
    end
  end
end
