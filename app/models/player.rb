class Player < ActiveRecord::Base
  attr_accessible :name, :totalScore, :totalWins

  has_and_belongs_to_many :games
end
