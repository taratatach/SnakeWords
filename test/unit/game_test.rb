require 'test_helper'

class GameTest < ActiveSupport::TestCase

  test "game has players" do    
    assert games(:gameOne).players.size > 0
  end

  test "dictionary exists" do
    assert File.file? "anglais.txt"
  end
  
  test "dictionary is loaded" do
    g = Game.new(5, "anglais.txt", nil)
    assert g.authorized? "aahed"
  end
end
