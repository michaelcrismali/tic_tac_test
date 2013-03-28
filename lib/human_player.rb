class HumanPlayer

  attr_accessor :which_player

  def initialize(which_player)
    @which_player = which_player
  end

  def mark_the_board(board, *test)
    puts "Please enter a number that corresponds to an unmarked space."
    puts "(psst, in case you forgot, you're #{@which_player}'s)"
    input = false
    input = test.first unless test.empty?
    while true
      input = get_human_input unless test.first.to_i > 0 && test.first.to_i < 10
      break if valid_human_input?(input, board)
    end
    board[input.to_i - 1] = @which_player unless board[input.to_i - 1].is_a? String
  end

  def get_human_input(*number_string)
    input = number_string.first unless number_string.empty?
    input ||= gets.chomp
  end

  def valid_human_input?(input, board)
    available_spaces = board.clone.delete_if {|x| x.is_a? String }
    input = input.to_i
    if available_spaces.include?(input)
      return true
    else
      puts "Invalid choice: only numbers that are greater than 0 or less than 10 "
      puts "that correspond to an unmarked space are accepted"
      return false
    end
  end
end
