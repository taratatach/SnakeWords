require 'test_helper'

class PlayedWordTest < ActiveSupport::TestCase
  
  def setup
    @p = played_words(:one)
  end
  
  test "word can be read" do
    assert_not_nil @p.word, "Word cannot be read"
  end
  
  test "played word has player" do
    assert_not_nil @p.player, "PlayedWord doesn't have a player"
  end
  
  test "letter is in grid" do
    assert @p.x < @p.game.size && @p.y < @p.game.size, "Letter isn't in the grid"
  end
  
  test "letter is in word" do
    assert_match /#{@p.letter}/, @p.word, "Letter #{@p.letter} isn't in Word #{@p.word}"
  end
  
  test "game of PlayedWord has players" do
    assert_not_nil @p.game.players
  end
  
  test "player is in game" do
    assert @p.game.players.include?(@p.player), "Player #{@p.player} isn't in game #{@p.game}"
  end
end
