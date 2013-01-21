require 'test_helper'

class GameTest < ActiveSupport::TestCase

  test "game has players" do    
    assert games(:gameOne).players.size > 0
  end

  # test "the truth" do
  #   assert true
  # end
end
