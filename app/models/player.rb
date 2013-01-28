class Player < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true

  attr_accessible :name, :totalScore, :totalWins, :games
  attr_reader :name, :totalScore, :totalWins, :games

  has_and_belongs_to_many :games
  
  def initialize(name)
    super()
    @name = name
    @totalScore = 0
    @totalWins = 0
  end

  def addWord(word)
    @totalScore += word.length
  end
  
  def addVictory
    @totalWins += 1
  end  
end
