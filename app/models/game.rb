class Game < ActiveRecord::Base
  validates :size, :presence => true, :numericality => true
  
  attr_accessible :dictionary, :finished, :size
  attr_reader :grid

  has_and_belongs_to_many :players

  def initialize(size, dictionary, players)
    @players = players
    @dictionary = dictionary
    @words = initDict()
    @playedWords = []
    @size = size
    @grid = initGrid()
    @finished = false
  end

  # Create size x size grid filled with nil and call insertWord
  def initGrid
    grid = Array.new(@size) { Array.new(@size, nil) }
    word = ""
    begin
      word = @words.keys[Random.rand(@words.size)]
    end while word.length > @size
    insertWord(word, grid)
    return grid
  end

  # Insert game's first word horizontaly in random place
  def insertWord(word, grid)
    x = Random.rand(@size)
    y = Random.rand(@size - word.length + 1)

    for i in 0...word.length
      grid[x][y+i] = word[i]
    end
  end

  # Load words from dictionary and fill in words
  def initDict
    words = {}
    file = File.open(@dictionary)
    file.each do |line|
      words[line[0..-2]] = 0
    end
    return words
  end

  # Return true if :word has already been played during the game
  def already_played?(word)
    for pw in @playedWords
      if pw.word == word
        return true
      end
    end
    return false
  end

  # Return true if the :word contains :letter, grid[:x][:y] is empty and :word is in dict
  def authorized?(letter, word, x, y)
    (0..@size-1).member?(x) && (0..@size-1).member?(y) (&& @grid[x][y] == nil) && 
      @words.include?(word) && (/#{letter}/ =~ word)
  end

  # Return true if :word can be found in grid with :letter in grid[:x][:y]
  def found?(letter, word, x, y)
    
  end

  # Create new PlayedWord object and add it to the list + insert letter in grid
  def saveMove(player, letter, word, x, y)
    @grid[x][y] = letter
    @playedWords.push(PlayedWord.new(player, letter, word, x, y))
    player.addWord(word)
  end
end
