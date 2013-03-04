class ComputerPlayer

  attr_accessor :which_player, :other_player

  def initialize(which_player)
    @which_player = which_player
    if @which_player == 'X'
      @other_player = 'O'
    else
      @other_player = 'X'
    end

  end

  def mark_the_board(game)
    selected_space = false

    selected_space = complete_for_win_or_block(game)

    selected_space ||= going_first_strategies(game) if @which_player == 'X'

    selected_space ||= going_second_strategies(game) if @which_player == 'O'

    selected_space ||= choose_line_towards_victory(game)

    selected_space ||= choose_center_if_available(game)

    selected_space ||= choose_corner_if_available(game)

    selected_space ||= choose_random_available_space

    game.board[game.board.index(selected_space)] = @which_player

  end

  def choose_center_if_available(game)
    if game.board.include?(5)
      return 5
    else
      return false
    end
  end

  def choose_corner_if_available(game)
    corners = [ 1, 3, 7, 9 ]
    board_clone = game.board.clone
    available_corners = board_clone.include_any?(corners)

    if available_corners
      return available_corners.last
    else
      return false
    end

  end

  def choose_random_available_space(game)
    board_clone = game.board.clone
    board_clone.delete_if {|x| x.is_a? String}
    return board_clone.sample
  end

  def complete_for_win_or_block(game)
    lines = game.get_lines
    selected_space = false

    lines.each do |line|
      if line.uniq.size == 2

        line_clone = line.clone.delete_if {|x| x.is_a? String}

        unless line_clone.empty?

          if line.include?(@which_player)
            selected_space = line_clone.first
          else
            selected_space ||= line_clone.first
          end
        end
      end
    end

    return selected_space
  end

  def choose_line_towards_victory(game)
    lines = game.get_lines
    selected_space = false
    lines.each do |line|
      if line.uniq.size == 3 && line.include?(@which_player)
        line_clone = line.clone.delete_if {|x| x.is_a? String}
        selected_space = line_clone.last
      end
    end
    return selected_space
  end

  def going_first_strategies(game)
    #three corner strat
    turns = how_many_turns(game)
    if turns[:cpu] == 0 || turns[:cpu] == 2
        selected_space = choose_corner_if_available(game)
      elsif turns[:cpu] == 1
        selected_space = 1 if game.board.include? 1
        selected_space ||= choose_corner_if_available(game)
      end
  end

  def going_second_strategies(game)

  end

  def block_three_corner_strategy(game)
    selected_space = false
    turns = how_many_turns(game)
    corners = game.board.values_at(0,8,2,6)

    if turns[:cpu] == 0 && corners.include?('X')
      if corners.index('X').odd?
        selected_space = corners[corners.index('X') - 1]
      else
        selected_space = corners[corners.index('X') + 1]
      end
    end

    return selected_space
  end



  def how_many_turns(game)
    board = game.board.clone
    turns = Hash.new
    turns[:human] = board.count {|x| x == @other_player}
    turns[:cpu] = board.count {|x| x == @which_player}
    return turns
  end

end
