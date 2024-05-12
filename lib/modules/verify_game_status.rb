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
    org_pos = piece.curr_pos
    target_piece = @board.at_square(new_pos)

    @board.place_piece(nil, org_pos)
    @board.place_piece(piece, new_pos)
    result = in_check?(@curr_player)

    @board.place_piece(piece, org_pos)
    @board.place_piece(target_piece, new_pos)

    result
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

  def mate?(color)
    in_check?(color) && no_legal_move?(color)
  end

  def no_legal_move?(color)
    player = color == 'white' ? @white : @black
    player.none? { |piece| can_make_legal_move?(piece) }
  end

  def can_make_legal_move?(piece)
    available_moves = next_capture_move(piece)
    available_moves << piece.next_move if piece.instance_of(Pawn)
    available_moves.any? { |new_pos| !will_in_check?(piece, new_pos) }
  end

  def stalemate?(color)
    !in_check?(color) && no_legal_move?(color)
  end
end
