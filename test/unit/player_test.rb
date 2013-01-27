require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @p1= Player.new("Erwan")
    puts @p1
  end
  
  test "player initialised" do
    assert_not_nil @p1, "player cannot be initialised"
  end
  
  test "player's totalScore is 0 at initialisation " do
    assert @p1.totalScore==0, "player is not correctly initialised"
  end
  
   test "player's totalWins is 0 at initialisation " do
    assert @p1.totalWins==0, "player is not correctly initialised"
  end
end
