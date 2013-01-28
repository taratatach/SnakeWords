class Game < ActiveRecord::Base
  validates :size, :presence => true, :numericality => true
  
  attr_accessible :dictionary, :finished, :size

  has_and_belongs_to_many :players
end
