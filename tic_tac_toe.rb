class Game
  def initialize
    @board = Board.new
    intro_dialogue
    assign_marker
  end

  def play
    @curr_player = @p1
    @board.display
    loop do
      puts "\n#{@curr_player.name} (#{@curr_player.marker}), enter a number to place your marker:"
      position = gets.chomp.to_i
      if !@board.occupied?(position) && @board.place.include?(position.to_s)
        @board.update(position, @curr_player.marker)
        break if winner?(@curr_player.marker, @curr_player.name)

        switch_players
      else
        puts 'Error! Invalid input.'
      end
    end
  end

  protected

  def intro_dialogue
    puts "Let's play Tic Tac Toe! \nEnter Player 1 Name:"
    name1 = gets.chomp
    puts 'Enter Player 2 Name:'
    name2 = gets.chomp
    @p1 = Player.new(name1)
    @p2 = Player.new(name2)
  end

  def assign_marker
    @p1.marker = 'X'.blue
    @p2.marker = 'O'.red
    puts "#{@p1.name} is #{@p1.marker} and #{@p2.name} is #{@p2.marker} \n"
  end

  def switch_players
    @curr_player = @curr_player == @p1 ? @p2 : @p1
  end

  def winner?(marker, name)
    if vertical_win?(marker) || horizontal_win?(marker) || diagonal_win?(marker)
      puts "#{name} wins the game!"
      true
    elsif draw?
      puts "It's a draw! No one wins :("
      true
    end
  end

  def draw?
    @board.place.all?(/[^0-9]/)
  end

  def diagonal_win?(marker)
    all_d = [
      [@board.place[0], @board.place[4], @board.place[8]],
      [@board.place[2], @board.place[4], @board.place[6]]
    ]
    true if all_d[0].all?(marker) || all_d[1].all?(marker)
  end

  def horizontal_win?(marker)
    all_h = [
      [@board.place[0], @board.place[1], @board.place[2]],
      [@board.place[3], @board.place[4], @board.place[5]],
      [@board.place[6], @board.place[7], @board.place[8]]
    ]
    true if all_h[0].all?(marker) || all_h[1].all?(marker) || all_h[2].all?(marker)
  end

  def vertical_win?(marker)
    all_v = [
      [@board.place[0], @board.place[3], @board.place[6]],
      [@board.place[1], @board.place[4], @board.place[7]],
      [@board.place[2], @board.place[5], @board.place[8]]
    ]
    true if all_v[0].all?(marker) || all_v[1].all?(marker) || all_v[2].all?(marker)
  end
end

class Board
  attr_reader :place

  def initialize
    @board = []
    @place = %w[1 2 3 4 5 6 7 8 9]
  end

  def display
    @board = ["\n#{@place[0]}", '|', @place[1], '|', @place[2],
              '-', '+', '-', '+', '-',
              @place[3], '|', @place[4], '|', @place[5],
              '-', '+', '-', '+', '-',
              @place[6], '|', @place[7], '|', @place[8]]
    @board.each_slice(5) { |x| puts x.join }

  end

  def update(position, marker)
    @place[position - 1] = marker
    display
  end

  def occupied?(position)
    if @place[position - 1] != 'X' && @place[position - 1] != 'O'
      false
    else
      true
    end
  end
end

class Player
  attr_reader :name
  attr_accessor :marker

  def initialize(name)
    @name = name
  end
end

class String
  def blue; "\033[34m#{self}\033[0m" end
  def red;  "\033[31m#{self}\033[0m" end
end

game = Game.new
game.play
