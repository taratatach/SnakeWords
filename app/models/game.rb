#
# Author : Erwan Guyader
#
class Game < ActiveRecord::Base
  validates :size, :presence => true, :numericality => true
  validates :players, :presence => true
  validates :dictionary, :presence => true

  attr_accessible :players, :dictionary, :size, :firstWord, :fwX, :fwY, :pass
  attr_reader :grid, :words

  has_and_belongs_to_many :players
  has_many :playedWords, :dependent => :destroy

  after_find :init_load
  after_initialize :init_create, :if => Proc.new { |game| game.grid == nil } # called only after creation

  @grid = nil
  @words = nil

  # Required actions to build the object after creation
  def init_create
    init_dict()
    @grid = Array.new(self.size) { Array.new(self.size, nil) }
    init_first_word()
    self.finished = false
  end

  # Required actions to rebuild the object after a find
  def init_load
    init_dict()
    @grid = Array.new(self.size) { Array.new(self.size, nil) }
    insert_word(self.firstWord, self.fwX, self.fwY)

    if (self.playedWords == nil)
      return
    end

    for pw in self.playedWords
      @grid[pw.x][pw.y] = pw.letter
    end
  end

  # Find random word in dictionary, set self.firstWord and insert it in random place
  def init_first_word()
    #"if (self.playedWords != nil)
#      return
#    end"

    self.firstWord = ""
    if (self.firstWord == nil)
      throw Exception.new "wtf ??!"
    end

    begin
      if (self.firstWord == nil)
        throw Exception.new "@words isn't responsible"
      end
      self.firstWord = @words.keys[Random.rand(@words.size)]
      if (self.firstWord == nil)
        throw Exception.new "self.firstWord is equal to nil"
      end
    end while self.firstWord.length > self.size

    self.fwX = Random.rand(self.size)
    self.fwY = Random.rand(self.size - self.firstWord.length + 1)
    
    insert_word(self.firstWord, self.fwX, self.fwY)
  end

  # Load words from dictionary and fill in words
  def init_dict
    @words = {}
    file = File.open(self.dictionary)
    file.each do |line|
      @words[line[0..-2]] = 0
    end
  end

  # Inserts word at given position
  def insert_word(word, x, y)
    for i in 0...word.length
      @grid[x][y+i] = word[i]
    end
  end

  # Return true if :word has already been played during the game
  def already_played?(word)
    if (self.playedWords == nil)
      return word == self.firstWord
    end

    for pw in self.playedWords
      if pw.word == word
        return true
      end
    end
    return word == self.firstWord
  end

  # Return true if the :word contains :letter, grid[:x][:y] is empty and :word is in dict
  def authorized?(letter, word, x, y)
    (0...self.size).member?(x) && (0...self.size).member?(y) && (@grid[x][y] == nil) &&
      @words.include?(word) && (/#{letter}/ =~ word)
  end

  # Return true if :word can be found in grid with :letter in grid[:x][:y]
  # Doesn't work for a word like DCBADR starting with A on the following grid :
  # CBC
  # DADR
  # because the D on the right could be checked by the 'left' function
  # while it should be checked by the 'right' function
  # think in terms of pointers arrays
  def possibilities(x, y, letter)
    p = []
    for i in x-1..x+1
      for j in y-1..y+1
        # if [i, j] isn't in the grid or not on the cross center on [x, y], continue
        if ((i < 0 || i >= self.size || j < 0 || j >= self.size) || (x-i != 0 && y-j != 0) || (i == x && j == y))
          next
        end

        if (@grid[i][j] == letter)
          p.push({x: i, y: j})
        end
      end
    end
    return p
  end

  def check(w, _x, _y)
    #puts "w="+w+", x="+_x.to_s+", y="+_y.to_s
    if (w.empty?)
      return []
    end

    result = []
    cells = possibilities(_x, _y, w[0])
    if (cells == [])
      return nil
    end

    for p in cells
      rest = check(w[1..-1], p[:x], p[:y])

      if (rest == nil)
        next
      elsif (rest == [])
        result.push([p])
      else
        rest.uniq.each do |r|
          result.push([p].concat(r))
        end
      end
      #result.push(step)

      #puts "word[1..-1] : " + w[1..-1]
      #puts "rest : " + rest.to_s
    end
    #puts "RESULT : " + result.to_s
    return result
  end

  def found?(letter, word, x, y)
    #puts "word="+word
    #puts "letter="+letter
    #puts "start = " + x.to_s + "-" + y.to_s
    
    start = 0
    while ((index = word.index(letter, start)) != nil)
      #puts "index = "+index.to_s
      # get all solutions for the left part of the word
      left = check(word[0...index].reverse, x, y)
      left = (left == [] || left == nil) ? [[]] : left
      #puts "\nleft = " + left.to_s
      # get all solutions for the right part of the word
      right = check(word[index+1..-1], x, y)
      right = (right == [] || right == nil) ? [[]] : right
      #puts "\nright = " + right.to_s
      left.each do |solL|
        right.each do |solR|
          # for each solution of each part, concatenate them with the letter to create a solution
          # we reverse the left part to have the real path for the word
          sol = solL.reverse.concat([{x: x, y: y}]).concat(solR)
          #puts "\n\nSOL : "+sol.to_s
          # if the solution doesn't use twice the same cell, it is valid
          if (sol.uniq.size == sol.size && sol.size == word.length)
            return true
          end
        end
      end
      start = index + 1
    end
    return false
  end  

  # Create new PlayedWord object and add it to the list + insert letter in grid
  # Set pass to false if true
  def saveMove(player, letter, word, x, y)
    if (self.pass?)
      self.update_attribute(:pass, false)
    end

    @grid[x][y] = letter
    self.playedWords << PlayedWord.new(game: self, player: player, letter: letter, word: word, x: x, y: y)
    player.addWord(word)

    # The grid is full, the game is finished
    if (self.playedWords.size + self.firstWord.length == self.size * self.size)
      end_game
    end
  end

  # Set pass to true if false; end Game otherwise
  def pass_turn
    if (self.pass?)
      end_game
    else
      self.update_attribute(:pass, true)
    end
  end

  # End game and set victor
  def end_game
    self.update_attribute(:finished, true)

    s1 = 0
    s2 = 0
    for pw in self.playedWords
      if (pw.player == self.players[0])
        s1 += pw.word.length
      else
        s2 += pw.word.length
      end
    end
    if (s1 > s2)
      players[0].addVictory
    elsif (s1 < s2)
      players[1].addVictory
    end
  end
end
