# frozen_string_literal: true

# Pieces in the chess game
class Pieces
  attr_reader :symbol, :curr_pos, :color

  def initialize(color, curr_pos)
    @color = color
    @curr_pos = curr_pos
  end

  def move_to(new_pos)
    @advanced_2_sqaures = instance_of?(Pawn) && advanced_move?(new_pos) ? true : false
    @curr_pos = new_pos
    @moved = true if [King, Rook, Pawn].include?(self.class)
  end

  def same_color?(piece)
    piece.color == @color
  end
end
