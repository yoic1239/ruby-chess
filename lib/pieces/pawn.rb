# frozen_string_literal: true

require_relative './pieces'

# The pawn moves two steps forward and one step to the side or one step forward and two steps to the side
class Pawn < Pieces
  attr_reader :advanced_2_sqaures, :moved

  def initialize(color, curr_pos)
    super(color, curr_pos)
    @symbol = @color == 'white' ? "\u2659" : "\e[0;35m\u265F\e[0m"
    @moved = false
    @advanced_2_sqaures = false
  end

  def next_move
    forward = @moved ? [1] : [1, 2]
    forward.map! { |move| move * -1 } if @color == 'black'
    forward.map do |move|
      rank = (@curr_pos[1].to_i + move).to_s
      @curr_pos[0] + rank if rank.between?('1', '8')
    end.compact
  end

  def capture_move
    movement = @color == 'white' ? [[1, -1], [1, 1]] : [[-1, -1], [1, 1]]
    movement.map do |rank_move, file_move|
      rank = (@curr_pos[1].to_i + rank_move).to_s
      file = (@curr_pos[0].ord + file_move).chr
      file + rank if rank.between?('1', '8') && file.between?('a', 'h')
    end.compact
  end

  def advanced_move?(new_pos)
    (new_pos[1].to_i - @curr_pos[1].to_i).abs == 2
  end

  def can_promote?
    @curr_pos[1] == if @color == 'white'
                      '8'
                    else
                      '1'
                    end
  end
end
