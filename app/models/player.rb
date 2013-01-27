class Player < ActiveRecord::Base
  attr_accessible :name, :totalScore, :totalWins

  has_and_belongs_to_many :games
  
  def initialize(name="")
    super()
    self.name = name
    self.totalScore = 0
    self.totalWins= 0
  end
end
