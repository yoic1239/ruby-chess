# frozen_string_literal: true

# Chessboard with 64 squares arranged in an 8×8 grid
class ChessBoard
  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def at_square(position)
    return unless position[0].between?('a', 'h') && position[1].between?('1', '8')

    row_idx = 8 - position[1].to_i
    col_idx = position[0].ord - 97
    @board[row_idx][col_idx]
  end

  # rubocop: disable Metrics/MethodLength
  def display
    puts "  ┌#{'───┬' * 7}───┐"
    @board.each_with_index do |row, row_idx|
      box = "\e[0;32m#{8 - row_idx}\e[0m │"

      row.each do |square|
        box += square ? " #{square.symbol} │" : '   │'
      end
      puts box
      puts "  ├#{'───┼' * 7}───┤" unless row_idx == 7
    end
    puts "  └#{'───┴' * 7}───┘"
    puts "\e[0;32m    A   B   C   D   E   F   G   H\e[0m"
  end
  # rubocop: enable Metrics/MethodLength
end
