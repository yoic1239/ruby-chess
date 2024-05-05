# frozen_string_literal: true

require_relative './pieces'

# The king moves one square in any direction, horizontally, vertically, or diagonally.
class King < Pieces
  def initialize(color, curr_pos)
    super(color, curr_pos)
    @symbol = @color == 'white' ? "\u2654" : "\u265A"
    @moved = false
  end

  def next_move
    curr_rank = @curr_pos[1].to_i
    curr_file = @curr_pos[0].ord

    [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].map do |rank_move, file_move|
      rank = (curr_rank + rank_move).to_s
      file = (curr_file + file_move).chr
      file + rank if rank.between?('1', '8') && file.between?('a', 'h')
    end.compact
  end

  def castling_move
    @color == 'white' ? %w[c1 e1] : %w[c8 e8]
  end
end
