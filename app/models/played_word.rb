class PlayedWord < ActiveRecord::Base
  attr_accessible :letter, :game, :player, :word, :x, :y

  belongs_to :game
  belongs_to :player
end
