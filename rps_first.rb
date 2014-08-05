

# Rock, Paper, Scissors
# Make a 2-player game of rock paper scissors. It should have the following:
#
# It is initialized with two strings (player names).
# It has a `play` method that takes two strings:
#   - Each string reperesents a player's move (rock, paper, or scissors)
#   - The method returns the winner (player one or player two)
#   - If the game is over, it returns a string stating that the game is already over
# It ends after a player wins 2 of 3 games
#
# You will be using this class in the following class, which will let players play
# RPS through the terminal.
class RPS
  attr_reader :player1, :player2, :p1score, :p2score

  def initialize (player1, player2)
    @player1 = player1
    @p1score = 0
    @player2 = player2
    @p2score = 0
  end

  def play (player1choice, player2choice)
    if player1choice == player2choice
      :tie
    elsif player1choice == "r"
      if player2choice == "s"
        increment(@player1)
      elsif player2choice == "p"
        increment(@player2)
      end
    elsif player1choice == "s"
      if player2choice == "r"
        increment(@player2)
      elsif player2choice == "p"
        increment(@player1)
      end
    elsif player1choice == "p"
      if player2choice == "r"
        increment(@player1)
      elsif player2choice == "s"
        increment(@player2)
      end
    end
  end

  def increment(player)
    if player == @player1
      @p1score += 1
      @p1score == 2 ? :gameover1 : :win1
    elsif player == @player2
      @p2score += 1
      @p2score == 2 ? :gameover2 : :win2
    end
  end
end

require 'io/console'
class RPSPlayer
  # (No specs are required for RPSPlayer)
  #
  # Complete the `start` method so that it uses your RPS class to present
  # and play a game through the terminal.
  #
  # The first step is to read (gets) the two player names. Feed these into
  # a new instance of your RPS class. Then `puts` and `gets` in a loop that
  # lets both players play the game.
  #
  # When the game ends, ask if the player wants to play again.
  def self.start
    puts "Enter Player 1 name:"
    player1name = gets.chomp
    puts "Enter Player 2 name:"
    player2name = gets.chomp
    game = RPS.new(player1name, player2name)
    play_turn(game, player1name, player2name)
  end
    
  def self.play_turn(game, player1name, player2name)
    puts "What is #{player1name}'s move?"
    p1move = STDIN.noecho(&:gets)[0].downcase
    puts "What is #{player2name}'s move?"
    p2move = STDIN.noecho(&:gets)[0].downcase
    if %w(r p s).include?(p1move && p2move)
      result = game.play(p1move, p2move)   
    else
      result = :error
    end
    if result == :win1
      puts "#{player1name} won this round!"
    elsif result == :win2
      puts "#{player2name} won this round!"
    elsif result == :gameover1 
      puts "Game Over! #{player1name} won 2 games!"
      return RPSPlayer.check_for_another_game
    elsif result == :gameover2
      puts "Game Over! #{player2name} won 2 games!"
      return RPSPlayer.check_for_another_game
    elsif result == :tie
      puts "It's a tie!"
    elsif result == :error
      puts 'Please make sure you enter "rock", "paper", or "scissors" correctly.  Let\'s try again.'
    end
    play_turn(game, player1name, player2name)
  end

  def self.check_for_another_game
    puts "Do you want to start a new game?"
    answer = gets.chomp
    if answer[0].downcase == "y"
      RPSPlayer.start
    else
      puts "Goodbye and good luck."
    end
  end


    

    # puts "Do you want to play again?"
    # answer = gets
    # if answer == "yes"
    #   RPSPlayer.start
    # else
    #   puts "Thanks for playing.  Goodbye and good luck."
    # end
    # TODO

    # PRO TIP: Instead of using plain `gets` for grabbing a player's
    #          move, this line does the same thing but does NOT show
    #          what the player is typing! :D
    # This is also why we needed to require 'io/console'
    # move = STDIN.noecho(&:gets)

end

