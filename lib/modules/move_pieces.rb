# frozen_string_literal: true

# Methods for moving piece in the Chess game
module MovePieces
  def move_piece(piece, new_pos)
    case type_of_move(piece, new_pos)
    when 'Basic', 'Pawn capture'
      remove_captured_piece(new_pos) if @board.at_square(new_pos)
      basic_move(piece, new_pos)
    when 'Castling'
      castling(piece, new_pos)
    when 'En passant'
      en_passant(piece, new_pos)
    end

    @last_move = piece
  end

  def basic_move(piece, new_pos)
    @board.place_piece(nil, piece.curr_pos)
    @board.place_piece(piece, new_pos)
    piece.move_to(new_pos)
  end

  def remove_captured_piece(position)
    target_piece = @board.at_square(position)
    @board.place_piece(nil, position)
    target_piece.color == 'white' ? @white.delete(target_piece) : @black.delete(target_piece)
  end

  def castling(king, new_pos)
    rook_pos = new_pos[0] == 'c' ? "a#{new_pos[1]}" : "h#{new_pos[1]}"
    rook = @board.at_square(rook_pos)
    rook_new_pos = new_pos[0] == 'c' ? "d#{new_pos[1]}" : "f#{new_pos[1]}"

    basic_move(king, new_pos)
    basic_move(rook, rook_new_pos)
  end

  def en_passant(pawn, new_pos)
    enemy_pos = new_pos[0] + pawn.curr_pos[1]
    remove_captured_piece(enemy_pos)
    basic_move(pawn, new_pos)
  end

  def promotion(pawn)
    new_piece = create_promotion_piece(pawn, promotion_type)
    if pawn.color == 'white'
      @white.delete(pawn)
      @white << new_piece
    else
      @black.delete(pawn)
      @black << new_piece
    end
    @board.place_piece(new_piece, pawn.curr_pos)
  end

  def promotion_type
    loop do
      puts 'Pawn promotion! What piece would you like to promote to? (Queen / Rook / Bishop / Knight)'
      type = gets.chomp.downcase
      return type if %w[queen bishop knight rook].include?(type)
    end
  end

  def create_promotion_piece(pawn, type)
    case type
    when 'queen'
      Queen.new(pawn.color, pawn.curr_pos)
    when 'bishop'
      Bishop.new(pawn.color, pawn.curr_pos)
    when 'knight'
      Knight.new(pawn.color, pawn.curr_pos)
    when 'rook'
      Rook.new(pawn.color, pawn.curr_pos)
    end
  end
end
