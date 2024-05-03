# frozen_string_literal: true

require_relative './pieces'
require_relative '../modules/move_straight_line'

# The queen moves in any straight line, horizontal, vertical, or diagonal.
class Queen < Pieces
  include MoveHorizontalVertical
  include MoveDiagonal

  def initialize(color, curr_pos)
    super(color, curr_pos)
    @symbol = @color == 'white' ? "\u2655" : "\u265B"
  end

  def next_move
    horizontal_line(@curr_pos) + vertical_line(@curr_pos) +
      left_diagonal_line(@curr_pos) + right_diagonal_line(@curr_pos)
  end

  def squares_to(new_pos)
    line = if in_same_rank?(@curr_pos, new_pos)
             horizontal_line(@curr_pos)
           elsif in_same_file?(@curr_pos, new_pos)
             vertical_line(@curr_pos)
           elsif in_same_left_diagonal_line?(@curr_pos, new_pos)
             left_diagonal_line(@curr_pos)
           elsif in_same_right_diagonal_line?(@curr_pos, new_pos)
             right_diagonal_line(@curr_pos)
           end

    line.select { |square| square.between?(*[@curr_pos, new_pos].sort) } - [new_pos]
  end
end
