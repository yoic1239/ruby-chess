# frozen_string_literal: true

require_relative './pieces'
require_relative '../modules/move_straight_line'

# The rook moves in a straight line, horizontally or vertically
class Rook < Pieces
  include MoveHorizontalVertical

  attr_reader :moved

  def initialize(color, curr_pos)
    super(color, curr_pos)
    @symbol = @color == 'white' ? "\u2656" : "\e[0;35m\u265C\e[0m"
    @moved = false
  end

  def next_move
    horizontal_line(@curr_pos) + vertical_line(@curr_pos)
  end

  def squares_to(new_pos)
    return unless next_move.include?(new_pos)

    squares = in_same_rank?(@curr_pos, new_pos) ? horizontal_line(@curr_pos) : vertical_line(@curr_pos)
    squares.select { |square| square.between?(*[curr_pos, new_pos].sort) } - [new_pos]
  end
end
