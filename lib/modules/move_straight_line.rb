# frozen_string_literal: true

# Pieces that can move in a straight line, horizontally or vertically.
module MoveHorizontalVertical
  def horizontal_line(curr_pos)
    ('a'..'h').map { |file| file + curr_pos[1] } - [curr_pos]
  end

  def vertical_line(curr_pos)
    ('1'..'8').map { |rank| curr_pos[0] + rank } - [curr_pos]
  end

  def in_same_rank?(curr_pos, new_pos)
    horizontal_line(curr_pos).include?(new_pos)
  end

  def in_same_file?(curr_pos, new_pos)
    vertical_line(curr_pos).include?(new_pos)
  end
end

# Pieces that can move in a straight diagonal line.
module MoveDiagonal
  def left_diagonal_line(curr_pos)
    curr_rank = curr_pos[1].to_i
    ('a'..'h').map do |file|
      adjust = curr_pos.ord - file.ord
      rank = curr_rank + adjust
      file + rank.to_s if rank.between?(1, 8)
    end.compact - [curr_pos]
  end

  def right_diagonal_line(curr_pos)
    curr_rank = curr_pos[1].to_i
    ('a'..'h').map do |file|
      adjust = curr_pos.ord - file.ord
      rank = curr_rank - adjust
      file + rank.to_s if rank.between?(1, 8)
    end.compact - [curr_pos]
  end

  def in_same_left_diagonal?(curr_pos, new_pos)
    left_diagonal_line(curr_pos).include?(new_pos)
  end

  def in_same_right_diagonal?(curr_pos, new_pos)
    right_diagonal_line(curr_pos).include?(new_pos)
  end
end
