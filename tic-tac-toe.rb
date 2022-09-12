class Game
  attr_reader :board, :positions

  def initialize
    @board = []
    @positions = [0, 2, 4, 10, 12, 14, 20, 22, 24]
  end

  def create_board
    @board = [
      '_0', '|', '_2', '|', '_4',
      '--', '|', '--', '|', '--',
      '10', '|', '12', '|', '14',
      '--', '|', '--', '|', '--',
      '20', '|', '22', '|', '24'
    ].each_slice(5) { |x| puts x.join }
  end

  def update_board(position = '', token = '')
    @board[position] = token
    @board = @board.each_slice(5) { |x| puts x.join }
  end

  def randomize_token
    tokens = %w[XX OO]
    tokens[(rand * tokens.length).floor]
  end

  def winner(token, name)
    if vertical_win?(token) || horizontal_win?(token) || diagonal_win?(token)
      puts "#{name} wins the game!"
      true
    elsif draw?
      puts "It's a draw! No one wins :("
      true
    end
  end

  def occupied?(position)
    if @board[position] == 'XX' || @board[position] == 'OO'
      true
    else
      false
    end
  end

  protected

  def draw?
    @board.none?(/\d/) && (!diagonal_win? || !horizontal_win? || !vertical_win?)
  end

  def diagonal_win?(token = '')
    all_d = [
      [@board[0], @board[12], @board[24]],
      [@board[4], @board[12], @board[20]]
    ]
    true if all_d[0].all?(token) || all_d[1].all?(token)
  end

  def vertical_win?(token = '')
    all_v = [
      [@board[0], @board[10], @board[20]],
      [@board[2], @board[12], @board[22]],
      [@board[4], @board[14], @board[24]]
    ]
    true if all_v[0].all?(token) || all_v[1].all?(token) || all_v[2].all?(token)
  end

  def horizontal_win?(token = '')
    all_h = [
      [@board[0], @board[2], @board[4]],
      [@board[10], @board[12], @board[14]],
      [@board[20], @board[22], @board[24]]
    ]
    true if all_h[0].all?(token) || all_h[1].all?(token) || all_h[2].all?(token)
  end
end

class Player
  attr_accessor :token, :position, :name

  def initialize(name)
    @name = name
  end
end

game = Game.new

# Get name from both players
puts "Ready to play Tic-Tac-Toe? \nEnter Player 1 Name:"
name = gets.chomp
puts 'Enter Player 2 Name:'
name2 = gets.chomp
player1 = Player.new(name)
player2 = Player.new(name2)
# get player 1 token
player1.token = game.randomize_token
# get player 2 token
player2.token = player1.token == 'XX' ? 'OO' : 'XX'
# get token
puts "#{player1.name} is Player #{player1.token} and " \
       "#{player2.name} is Player #{player2.token}." \
        "\n#{player1.name} plays first!"
game.create_board

curr_player = player1

def game_start(player, game_obj, p1, p2)
  while true
    puts game_dialog(player.token, player.name)
    player.position = gets.chomp.to_i
    if valid_input?(game_obj.positions, player.position, game_obj)
      game_obj.update_board(player.position, player.token)
      return if game_obj.winner(player.token, player.name)
      player = player == p1 ? p2 : p2
    end
  end
end

def valid_input?(positions, choice, game_obj)
  if positions.include?(choice) && !game_obj.occupied?(choice)
    true
  else
    puts "\nError! Please enter a valid input."
    game_obj.update_board
    false
  end
end

def game_dialog(token, name)
  "\nPlayer #{token} (#{name}): Enter a number from the board to place a token."
end

game_start(curr_player, game, player1, player2)
