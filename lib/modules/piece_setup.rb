# frozen_string_literal: true

require_relative '../pieces/king'
require_relative '../pieces/queen'
require_relative '../pieces/bishop'
require_relative '../pieces/knight'
require_relative '../pieces/rook'
require_relative '../pieces/pawn'

# Setup
module PieceSetup
  def set_initial_pieces
    set_king
    set_queen
    set_bishop
    set_knight
    set_rook
    set_pawn
  end

  def set_king
    init_pos = { 'white' => 'e1', 'black' => 'e8' }
    init_pos.each do |color, position|
      piece = King.new(color, position)
      color == 'white' ? @white << piece : @black << piece
      @board.place_piece(piece, position)
    end
  end

  def set_queen
    init_pos = { 'white' => 'd1', 'black' => 'd8' }
    init_pos.each do |color, position|
      piece = Queen.new(color, position)
      color == 'white' ? @white << piece : @black << piece
      @board.place_piece(piece, position)
    end
  end

  def set_bishop
    init_pos = { 'white' => %w[c1 f1], 'black' => %w[c8 f8] }
    init_pos.each do |color, positions|
      positions.each do |position|
        piece = Bishop.new(color, position)
        color == 'white' ? @white << piece : @black << piece
        @board.place_piece(piece, position)
      end
    end
  end

  def set_knight
    init_pos = { 'white' => %w[b1 g1], 'black' => %w[b8 g8] }
    init_pos.each do |color, positions|
      positions.each do |position|
        piece = Knight.new(color, position)
        color == 'white' ? @white << piece : @black << piece
        @board.place_piece(piece, position)
      end
    end
  end

  def set_rook
    init_pos = { 'white' => %w[a1 h1], 'black' => %w[a8 h8] }
    init_pos.each do |color, positions|
      positions.each do |position|
        piece = Rook.new(color, position)
        color == 'white' ? @white << piece : @black << piece
        @board.place_piece(piece, position)
      end
    end
  end

  def set_pawn
    init_pos = { 'white' => ('a'..'h').map { |file| "#{file}2" }, 'black' => ('a'..'h').map { |file| "#{file}7" } }
    init_pos.each do |color, positions|
      positions.each do |position|
        piece = Pawn.new(color, position)
        color == 'white' ? @white << piece : @black << piece
        @board.place_piece(piece, position)
      end
    end
  end
end
