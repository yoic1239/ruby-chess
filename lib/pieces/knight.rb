# frozen_string_literal: true

require_relative './pieces'

# The knight moves two steps forward and one step to the side or one step forward and two steps to the side
class Knight < Pieces
  def initialize(color, curr_pos)
    super(color, curr_pos)
    @symbol = @color == 'white' ? "\u2658" : "\u265E"
  end

  def next_move
    curr_rank = @curr_pos[1].to_i
    curr_file = @curr_pos[0].ord

    [[1, 2], [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]].map do |rank_move, file_move|
      rank = (curr_rank + rank_move).to_s
      file = (curr_file + file_move).chr
      file + rank if rank.between?('1', '8') && file.between?('a', 'h')
    end.compact
  end
end
