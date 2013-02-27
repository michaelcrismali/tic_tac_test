require 'test/unit'
require './human_player.rb'

class HumanPlayerTest < Test::Unit::TestCase

  def setup
    @player = HumanPlayer.new
  end

  def test_human_player_is_a_class
    assert_kind_of Class, HumanPlayer
  end

  def test_has_a_mark_the_board_method
    assert_respond_to @player, :mark_the_board, 'No mark the board method'
  end

  def test_mark_the_board_accepts_an_argument

    assert_nothing_raised(ArgumentError) {@player.mark_the_board('X')}

  end



end
