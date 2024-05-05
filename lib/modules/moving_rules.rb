# frozen_string_literal: true

# Pieces that can move in a straight line, horizontally or vertically.
module MovingRules
  def leap_over_others?(piece, new_pos)
    path = piece.squares_to(new_pos)
    path.any? do |position|
      @board.at_square(position)
    end
  end

  def allow_en_passant?(pawn, new_pos)
    enemy_pos = new_pos[0] + pawn.curr_pos[1]
    enemy = @board.at_square(enemy_pos)
    enemy.instance_of?(Pawn) && enemy.advanced_2_sqaures && @last_move == enemy
  end
end
