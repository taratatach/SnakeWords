class Player < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true

  attr_accessible :name

  has_and_belongs_to_many :games, :dependent => :destroy

  after_initialize :default_scores

  def default_scores
    self.totalScore ||= 0
    self.totalWins ||= 0
  end

  def addWord(word)
    self.totalScore += word.length
  end
  
  def addVictory
    self.totalWins += 1
  end  
end
