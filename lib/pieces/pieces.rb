# frozen_string_literal: true

# Pieces in the chess game
class Pieces
  attr_reader :symbol, :curr_pos

  def initialize(color, curr_pos)
    @color = color
    @curr_pos = curr_pos
  end

  def move_to(new_pos)
    @curr_pos = new_pos
  end
end
