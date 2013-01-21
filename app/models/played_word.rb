class PlayedWord < ActiveRecord::Base
  attr_accessible :game, :letter, :player, :word, :x, :y

  belongs_to :game
  belongs_to :player
end
