class Game
  attr_reader :board

  def initialize
    @board = []
  end

  def create_board
    @board = [
      'a', ' ', '_', '|', '_', '|',  '_',
      'b', ' ', '_', '|', '_', '|',  '_',
      'c', ' ', '_', '|', '_', '|',  '_',
      ' ', ' ', '1', ' ', '2', ' ',  '3'
    ].each_slice(7) { |x| puts x.join }
  end

  def update_board(position = "", token = "")
    case position
    when '1a'
      @board[2] = token
    when '1b'
      @board[4] = token
    when '1c'
      @board[6] = token
    when '2a'
      @board[9] = token
    when '2b'
      @board[11] = token
    when '2c'
      @board[13] = token
    when '3a'
      @board[16] = token
    when '3b'
      @board[18] = token
    when '3c'
      @board[20] = token
    end
    @board = @board.each_slice(7) { |x| puts x.join }
  end

  def occupied?(position)
    
  end

  def randomize_token
    tokens = %w[x o]
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

  protected

  def draw?
    @board.none?('_') && (!diagonal_win? || !horizontal_win? || !vertical_win?)
  end

  def diagonal_win?(token = '')
    all_d = [
      [@board[2], @board[11], @board[20]],
      [@board[6], @board[11], @board[16]]
    ]
    p "Track Diagonal: #{all_d}"
    true if all_d[0].all?(token) || all_d[1].all?(token)
  end

  def vertical_win?(token = '')
    all_v = [
      [@board[2], @board[9], @board[16]],
      [@board[4], @board[11], @board[18]],
      [@board[6], @board[13], @board[20]]
    ]
    p "Track Vertical: #{all_v}"
    true if all_v[0].all?(token) || all_v[1].all?(token) || all_v[2].all?(token)
  end

  def horizontal_win?(token = '')
    all_h = [
      [@board[2], @board[4], @board[6]],
      [@board[9], @board[11], @board[13]],
      [@board[16], @board[18], @board[20]]
    ]
    p "Track Horizontal: #{all_h}"
    true if all_h[0].all?(token) || all_h[1].all?(token) || all_h[2].all?(token)
  end
end

class Player
  attr_accessor :token, :position, :name

  def initialize(name)
    @name = name
    @number_of_turns = 0
  end

  def num_of_turns
    @number_of_turns += 1
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
player2.token = player1.token == 'x' ? 'o' : 'x'
# get token
puts "#{player1.name} is #{player1.token} and #{player2.name} is #{player2.token}.
        #{player1.name} plays first!"
game.create_board

curr_player = player1
positions = %w[
  1a 1b 1c
  2a 2b 2c
  3a 3b 3c
]
x = 0
no_break = true
while no_break
  puts "\n#{curr_player.name}, enter a coordinate. Ex: 1a."
  curr_player.position = gets.chomp
  if positions.include?(curr_player.position)
    game.update_board(curr_player.position, curr_player.token)
    break if game.winner(curr_player.token, curr_player.name)

    curr_player = curr_player == player1 ? player2 : player1
    x += 1
    puts "Current # of turns: #{x}"
  else
    puts "\nInput Error! Please enter a coordinate."
  end
end
