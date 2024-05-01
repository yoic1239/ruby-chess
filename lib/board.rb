# frozen_string_literal: true

# Chessboard with 64 squares arranged in an 8×8 grid
class ChessBoard
  def initialize
    @board = Array.new(8) { Array.new(8) }
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
