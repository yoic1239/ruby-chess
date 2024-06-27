# frozen_string_literal: true

require 'yaml'

# To save the game at any time
module SaveGame
  def save_game
    Dir.mkdir('save') unless Dir.exist?('save')
    datetime = Time.now.strftime('%y%m%d%H%M%S')
    filename = "save/saved_game_#{datetime}.yml"
    File.open(filename, 'w') do |file|
      file.puts to_yaml
    end
    File.delete(@load_file) if @load_file
    @saved = true
  end

  def to_yaml
    YAML.dump({
                board: @board,
                white: @white,
                black: @black,
                curr_player: @curr_player
              })
  end

  def load_saved_game
    permitted_classes = [ChessBoard, Rook, Bishop, Queen, King, Knight, Pawn, Symbol]
    load_file = select_saved_game
    saved_game = YAML.safe_load_file(load_file, permitted_classes: permitted_classes, aliases: true)
    @board = saved_game[:board]
    @white = saved_game[:white]
    @black = saved_game[:black]
    @curr_player = saved_game[:curr_player]
    @load_file = load_file
  end

  def incompleted_games?
    Dir.glob('save/saved_game_*.yml').any?
  end

  def to_load_saved_game?
    saved_games = Dir.glob('save/saved_game_*.yml')
    loop do
      puts 'You have previously saved game(s). Do you want to continue to play? (Y/N)'
      saved_games.each { |game| puts "- #{game}" }
      load_game = gets.chomp.downcase
      next unless %w[y n].include?(load_game)

      return load_game == 'y'
    end
  end

  def select_saved_game
    saved_games = Dir.glob('save/saved_game_*.yml')
    loop do
      puts 'Which saved game would you like to load? Please enter corresponding option number.'
      saved_games.each_with_index { |game, index| puts "\e[0;32m[#{index + 1}]\e[0m #{game}" }
      option = gets.chomp
      return saved_games[option.to_i - 1] if option.match?(/\d/) && option.to_i.between?(1, saved_games.length)
    end
  end
end
