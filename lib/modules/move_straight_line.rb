# frozen_string_literal: true

# Pieces that can move in a straight line, horizontally or vertically.
module MoveHorizontalVertical
  def horizontal_line(curr_pos)
    ('a'..'h').map { |file| file + curr_pos[1] }.delete(curr_pos)
  end

  def vertical_line(curr_pos)
    ('1'..'8').map { |rank| curr_pos[0] + rank }.delete(curr_pos)
  end

  def in_same_rank?(curr_pos, new_pos)
    horizontal_line(curr_pos).include?(new_pos)
  end

  def in_same_file?(curr_pos, new_pos)
    vertical_line(curr_pos).include?(new_pos)
  end
end
