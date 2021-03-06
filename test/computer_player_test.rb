system 'clear'

require 'test/unit'
require '../lib/board.rb'
require '../lib/game.rb'
require '../lib/computer_player.rb'

class ComputerPlayerTest < Test::Unit::TestCase

  def setup
    @cpu = ComputerPlayer.new(:X)
    @game = Game.new
  end

  def test_cpu_player_is_real_class
    assert_kind_of ComputerPlayer, @cpu
  end

  def test_cpu_has_which_player_method_and_attribute
    assert_respond_to @cpu, :which_player, 'No which_player method'
    assert_equal :X, @cpu.which_player
  end

  def test_cpu_has_mark_the_board_method
    assert_respond_to @cpu, :mark_the_board
  end

  def test_mark_the_board_accepts_an_argument
    assert_nothing_raised(ArgumentError) {@cpu.mark_the_board(@game.board)}
  end

  def test_cpu_has_complete_for_win_or_block_method
    assert_respond_to @cpu, :complete_for_win_or_block
  end

  def test_cpus_complete_for_win_or_block_method_accepts_an_argument
    assert_nothing_raised(ArgumentError) {@cpu.complete_for_win_or_block(@game.board)}
  end

  def test_complete_for_win_or_block_returns_false_if_it_cant_block_or_complete_for_win
    assert_equal false, @cpu.complete_for_win_or_block(@game.board)
  end

  def test_cfw_or_block_returns_number_of_space_to_block
    @game.board[0] = :O
    @game.board[1] = :O
    assert_equal 3, @cpu.complete_for_win_or_block(@game.board)
  end

  def test_cfw_or_block_returns_number_of_space_to_complete_for_win
    @game.board[0] = :X
    @game.board[1] = :X
    assert_equal 3, @cpu.complete_for_win_or_block(@game.board)
  end

  def test_cfw_or_block_completes_for_win_rather_than_blocking_when_both_possible
    @game.board[0] = :O
    @game.board[1] = :O
    @game.board[6] = :X
    @game.board[7] = :X
    assert_equal 9, @cpu.complete_for_win_or_block(@game.board)
  end

  def test_cfw_or_block_returns_false_when_line_is_fully_marked
    @game.board = Board.new( [ :X, :O, :O, 4, 5, 6, 7, 8, 9 ] )
    assert_equal false, @cpu.complete_for_win_or_block(@game.board)
  end

  def test_choose_random_available_space
    @game.board = [ :X, :O, :O, :X, :O, :O, :X, :O, 9 ]
    assert_equal 9, @cpu.choose_random_available_space(@game.board)
  end

  def test_cras_method_wont_return_letter
    @game.board = Board.new( [ :X, :O, :O, 4, 5, 6, 7, 8, 9 ] )
    assert_kind_of Integer, @cpu.choose_random_available_space(@game.board)
  end

  def test_choose_line_towards_victory_selects_properly
    @game.board = Board.new( [ 1, 2, 3, :O, :O, :X, 7, 8, 9 ] )
    assert_equal 9, @cpu.choose_line_towards_victory(@game.board)
  end

  def test_choose_line_towards_victory_returns_false_if_criteria_is_not_met
    assert_equal false, @cpu.choose_line_towards_victory(@game.board)
  end

  def test_choose_corner_if_available_returns_corner
    @game.board = Board.new( [ 1, 2, 3, :O, :O, :X, 7, 8, 9 ] )
    assert_equal 9, @cpu.choose_corner_if_available(@game.board)
  end

  def test_ccia_returns_corner_other_than_nine
    @game.board = Board.new( [ 1, 2, 3, :O, :O, :X, 7, 8, :O ] )
    assert_equal 7, @cpu.choose_corner_if_available(@game.board)
  end

  def test_ccia_returns_false_if_no_corners_available
    @game.board = Board.new( [ :O, 2, :O, :O, :O, :X, :X, 8, :X ] )
    assert_equal false, @cpu.choose_corner_if_available(@game.board)
  end

  def test_choose_center_if_available_returns_center_if_available
    assert_equal 5, @cpu.choose_center_if_available(@game.board)
  end

  def test_choose_center_returns_false_when_center_not_available
    @game.board[4] = :X
    assert_equal false, @cpu.choose_center_if_available(@game.board)
  end

  def test_mark_the_board_changes_board_in_game_object
    @game2 = Game.new
    @cpu.mark_the_board(@game.board)
    assert_not_equal @game2.board, @game.board
    assert_equal false, (@game2.board == @game.board)
  end

  def test_responds_to_block_double_loss_strategy
    assert_respond_to @cpu, :block_double_loss_strategy
  end

  def test_responds_to_play_double_loss_strategy
    assert_respond_to @cpu, :play_double_loss_strategy
  end

  def responds_to_how_many_turns_method
    assert_respond_to @cpu, :how_many_turns
  end

  def test_how_many_turns_returns_proper_values
    @game.board = Board.new( [  1, 2, 3, :X, :X, :O, 7, 8, 9 ] )
    turns = @cpu.how_many_turns(@game.board)
    assert_equal 2, turns
  end

  def test_how_many_turns_returns_proper_values_when_cpu_goes_second
    @cpu = ComputerPlayer.new(:O)
    @game.board = [  1, 2, 3, :X, :X, :O, 7, 8, 9 ]
    turns = @cpu.how_many_turns(@game.board)
    assert_equal 1, turns
  end

  def test_play_double_loss_strategy_plays_right_on_first_move
    cpu_choice = @cpu.play_double_loss_strategy(@game.board)
    @game.board[@game.board.index(cpu_choice)] = @cpu.which_player
    assert_equal :X, @game.board[8]
  end

  def test_pdls_works_when_human_chooses_center_first
    @game.board[8] = :X
    @game.board[4] = :O
    cpu_choice = @cpu.play_double_loss_strategy(@game.board)
    @game.board[@game.board.index(cpu_choice)] = @cpu.which_player
    assert_equal :X, @game.board[0]
  end

  def test_pdls_works_when_human_chooses_center_then_chooses_corner
    @game.board[8] = :X
    @game.board[4] = :O
    @game.board[0] = :X
    @game.board[2] = :O
    cpu_choice = @cpu.play_double_loss_strategy(@game.board)
    @game.board[@game.board.index(cpu_choice)] = @cpu.which_player
    assert_equal :X, @game.board[6]
  end

  def test_pdls_works_when_human_chooses_corner_first
    @game.board[8] = :X
    @game.board[2] = :O
    cpu_choice = @cpu.play_double_loss_strategy(@game.board)
    @game.board[@game.board.index(cpu_choice)] = @cpu.which_player
    assert_equal :X, @game.board[0]
  end

  def test_pdls_works_when_human_chooses_corner_then_chooses_center
    @game.board[8] = :X
    @game.board[2] = :O
    @game.board[0] = :X
    @game.board[4] = :O
    cpu_choice = @cpu.play_double_loss_strategy(@game.board)
    @game.board[@game.board.index(cpu_choice)] = @cpu.which_player
    assert_equal :X, @game.board[6]
  end

  def test_pdls_works_when_human_chooses_opposite_corner_first
    @game.board[8] = :X
    @game.board[0] = :O
    cpu_choice = @cpu.play_double_loss_strategy(@game.board)
    @game.board[@game.board.index(cpu_choice)] = @cpu.which_player
    assert_equal :X, @game.board[6]
  end

  def test_pdls_works_when_human_chooses_opposite_corner_first_then_blocks_cpu
    @game.board[8] = :X
    @game.board[0] = :O
    @game.board[6] = :X
    @game.board[7] = :O
    cpu_choice = @cpu.play_double_loss_strategy(@game.board)
    @game.board[@game.board.index(cpu_choice)] = @cpu.which_player
    assert_equal :X, @game.board[2]
  end

  def test_pdls_works_when_human_chooses_opposite_corner_first_then_blocks_cpu
    @game.board[8] = :X
    @game.board[0] = :O
    @game.board[6] = :X
    @game.board[7] = :O
    cpu_choice = @cpu.play_double_loss_strategy(@game.board)
    @game.board[@game.board.index(cpu_choice)] = @cpu.which_player
    assert_equal [:O,2,:X,4,5,6,:X,:O,:X], @game.board
  end

  def test_bdls_blocks_3_corner_strategy
    @game.board[0] = :X
    @cpu.which_player = :O
    @cpu.mark_the_board(@game.board)
    @game.board[8] = :X
    @cpu.mark_the_board(@game.board)
    @game.board[6] = :X
    @cpu.mark_the_board(@game.board)
    assert_equal true, @game.anybody_win?
  end

  def test_bdls_blocks_the_side_then_corner_corner_double_loss_scenario_2914
    @game.board[1] = :X
    @cpu.which_player = :O
    @cpu.mark_the_board(@game.board)
    @game.board[8] = :X
    @cpu.mark_the_board(@game.board)
    assert_equal :O, @game.board[2]
  end

  def test_bdls_blocks_the_side_then_corner_corner_double_loss_scenario_variant_2736
    @game.board[1] = :X
    @cpu.which_player = :O
    @cpu.mark_the_board(@game.board)
    @game.board[6] = :X
    @cpu.mark_the_board(@game.board)
    assert_equal :O, @game.board[0]
  end

  def test_bdls_blocks_the_side_then_corner_corner_double_loss_scenario_variant_6139
    @game.board[5] = :X
    @cpu.which_player = :O
    @cpu.mark_the_board(@game.board)
    @game.board[0] = :X
    @cpu.mark_the_board(@game.board)
    assert_equal :O, @game.board[2]
  end

  def test_bdls_blocks_the_side_then_corner_corner_double_loss_scenario_variant_4317
    @game.board[3] = :X
    @cpu.which_player = :O
    @cpu.mark_the_board(@game.board)
    @game.board[2] = :X
    @cpu.mark_the_board(@game.board)
    assert_equal :O, @game.board[0]
  end

  def test_unmarked_spaces_returns_proper_values
    @game.board = [:O,2,:X,4,5,6,:X,:O,:X]
    assert_equal [2,4,5,6], @cpu.unmarked_spaces(@game.board)
  end

  def test_unmarked_spaces_returns_proper_values_when_passed_a_smaller_array
    assert_equal [1,3], @cpu.unmarked_spaces([:X,1,:O,3])
  end

  def test_bdls_can_handle_2_opposite_sides_being_chosen_like_28_or_46
    @cpu.which_player = :O
    @cpu.other_player = :X
    @game.board[1] = :X
    @game.board[4] = :O
    @game.board[7] = :X
    assert_not_equal 5, @cpu.block_double_loss_strategy(@game.board)
  end

  def test_mark_the_board_chooses_center_when_first_turn_going_second
    @cpu.which_player = :O
    @cpu.other_player = :X
    @game.board[0] = :X
    board_clone = @game.board.clone
    board_clone[4] = :O
    @cpu.mark_the_board(@game.board)
    assert_equal board_clone, @game.board
  end

end
