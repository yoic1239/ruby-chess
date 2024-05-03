# frozen_string_literal: true

require_relative './pieces'
require_relative '../modules/move_straight_line'

# The bishop moves in a straight diagonal line
class Bishop < Pieces
  include MoveDiagonal

  def initialize(color, curr_pos)
    super(color, curr_pos)
    @symbol = @color == 'white' ? "\u2657" : "\u265D"
  end

  def next_move
    left_diagonal_line(@curr_pos) + right_diagonal_line(@curr_pos)
  end

  def squares_to(new_pos)
    return unless next_move.include?(new_pos)

    squares = in_same_left_diagonal?(@curr_pos, new_pos) ? left_diagonal_line(@curr_pos) : right_diagonal_line(@curr_pos)
    squares.select { |square| square.between?(*[curr_pos, new_pos].sort) }.delete(new_pos)
  end
end
