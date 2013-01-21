class Game < ActiveRecord::Base
  attr_accessible :dictionary, :finished, :size

  has_and_belongs_to_many :players
end
