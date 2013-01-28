require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  def setup
    @p1= Player.new("Erwan")
  end
  
  test "player initialized" do
    assert_not_nil @p1, "player cannot be initialized"
  end
  
  test "player's totalScore is 0 at initialization " do
    assert_equal 0, @p1.totalScore, "player is not correctly initialized"
  end
  
  test "player's totalWins is 0 at initialization " do
    assert_equal 0, @p1.totalWins, "player is not correctly initialized"
  end
end
