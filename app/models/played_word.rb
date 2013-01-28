class PlayedWord < ActiveRecord::Base
  attr_accessible :letter, :player, :word, :x, :y

  belongs_to :player

  def initialize(player, letter, word, x, y)
    @player = player
    @letter = letter
    @word = word
    @x = x
    @y = y
  end
end
