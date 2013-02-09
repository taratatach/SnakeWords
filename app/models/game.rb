class Game < ActiveRecord::Base
  validates :size, :presence => true, :numericality => true
  validates :players, :presence => true
  validates :dictionary, :presence => true

  attr_accessible :players, :dictionary, :size, :playedWords
  attr_reader :grid

  has_and_belongs_to_many :players
  has_many :playedWords, :dependent => :destroy

  after_find :init_game

  

 
 
  after_initialize :init, :if => Proc.new { |game| game.grid == nil } # called only after creation

  def init
    init_game()
    insertFirstWord()
    self.finished = false
  end

  def init_game
     puts "i am in init_game before init_dict"
    initDict()
    @grid = Array.new(self.size) { Array.new(self.size, nil) }
    puts "i am in init_game"
    construct_grid()
  end

  def construct_grid
    puts "i am in construct 1"
    if (self.playedWords == nil)
      return
    end
puts "i am in construct"
    for pw in self.playedWords
      @grid[pw.x][pw.y] = pw.letter
    end
  end
 # Create new PlayedWord object and add it to the list + insert letter in grid
  def saveMove(player, letter, word, x, y)
        
    @grid[x][y] = letter
    self.playedWords << PlayedWord.new(game: self, player: player, letter: letter, word: word, x: x, y: y)
    self.save()
    player.addWord(word)
  end
  # Insert game's first word horizontaly in random place
  private
  def insertFirstWord()

    if (self.playedWords != nil)
      return
    end
    
    word = ""
    begin
      word = @words.keys[Random.rand(@words.size)]
    end while word.length > self.size
    
    x = Random.rand(self.size)
    y = Random.rand(self.size - word.length + 1)
  
    for i in 0...word.length
      @grid[x][y+i] = word[i]
    
    end
  end

  # Load words from dictionary and fill in words
  def initDict    
    @words = {}
    file = File.open(self.dictionary)
    file.each do |line|
      @words[line[0..-2]] = 0
    end
  end

  # Return true if :word has already been played during the game
  def already_played?(word)
    if (@playedWords == nil)
      return false
    end

    for pw in @playedWords
      if pw.word == word
        return true
      end
    end
    return false
  end

  # Return true if the :word contains :letter, grid[:x][:y] is empty and :word is in dict
  def authorized?(letter, word, x, y)
    (0..@size-1).member?(x) && (0..@size-1).member?(y) && (@grid[x][y] == nil) && 
      @words.include?(word) && (/#{letter}/ =~ word)
  end

  # Return true if :word can be found in grid with :letter in grid[:x][:y]
  # Doesn't work for a word like DCBADR starting with A on the following grid :
  #                                CBC
  #                                DADR
  # because the D on the right could be checked by the 'left' function 
  #  while it should be checked by the 'right' function
  # think in terms of pointers arrays
  def possibilities(x, y, letter)
    # TODO
  end

  def check(w, _x, _y)
    # TODO
    return true
  end

  def found?(letter, word, x, y)
    start = 0
    while ((index = word.index(letter, start)) != nil)
      if (check(w[0..index], x, y, -1) && check(w[index..-1], x, y, 0))
        return true
      end
      start = index + 1
    end
    return false
  end
  

   

#  def found?(letter, word, x, y)
    # if (@grid[x][y] != letter)
    #   return false
    # end

    # checked = Array.new(@size*@size, false)

    # # recursive function to check if word w can be found starting at @grid[_x][_y]
    # def check(w, _x, _y, pos)
    #   if (w == nil || w.length == 0)
    #     return true
    #   end
      
    #   checked[@size*_y+_x] = true
    #   left = pos < 0 # pos = -1 to go to the left, 0 to go to the right
    #   nw = (left) ? w[0..(pos-1)] : w[1..-1]

    #   if (@grid[_x][_y+1] == w[pos] && !checked[@size*(_y+1)+_x] && check(nw, _x, _y+1, pos))
    #     return true
    #   end
    #   if (@grid[_x][_y-1] == w[pos] && !checked[@size*(_y-1)+_x] && check(nw, _x, _y-1, pos))
    #     return true
    #   end
    #   if (@grid[_x+1][_y] == w[pos] && !checked[@size*_y+_x+1] && check(nw, _x+1, _y, pos))
    #     return true
    #   end
    #   if (@grid[_x-1][_y] == w[pos] && !checked[@size*_y+_x-1] && check(nw, _x-1, _y, pos))
    #     return true
    #   end

    #   checked[@size*_y+_x] = false
    #   return false
    # end
    
    # start = 0
#  end

 
end
