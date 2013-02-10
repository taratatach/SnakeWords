require 'test_helper'

class GameTest < ActiveSupport::TestCase

  test "game has players" do    
    assert games(:gameOne).players.size > 0
  end

  test "dictionary exists" do
    assert File.file? "anglais.txt"
  end
  
  test "dictionary is loaded" do
    p1 = Player.new(name: "Georges")
    p2 = Player.new(name: "Georginette")
    g = Game.new({:size => 5, :dictionary => "anglais.txt", :players => [p1, p2]})
    assert !g.words.empty?, "@words is empty"
  end

  test "first word is saved and loaded correctly" do
    p1 = Player.new(name: "Georges")
    p2 = Player.new(name: "Georginette")
    g = Game.new({:size => 5, :dictionary => "anglais.txt", :players => [p1, p2]})
    p1.save()
    p2.save()
    g.save()
    lg = Game.where(:firstWord => g.firstWord)[0]
    assert_not_nil lg, "load didn't work"
    assert_equal g.firstWord, lg.firstWord, "save didn't work"
  end

  test "first word's position is saved properly" do
    p1 = Player.new(name: "Georges")
    p2 = Player.new(name: "Georginette")
    g = Game.new({:size => 5, :dictionary => "anglais.txt", :players => [p1, p2]})
    p1.save()
    p2.save()
    g.save()
    lg = Game.where(:firstWord => g.firstWord)[0]
    assert_equal g.fwX, lg.fwX, "x position isn't saved properly"
    assert_equal g.fwY, lg.fwY, "y position isn't saved properly"
  end

  test "first word is inserted at the right position after load" do
    p1 = Player.new(name: "Georges")
    p2 = Player.new(name: "Georginette")
    g = Game.new({:size => 5, :dictionary => "anglais.txt", :players => [p1, p2]})
    p1.save()
    p2.save()
    g.save()
    lg = Game.where(:firstWord => g.firstWord)[0]
    for i in 0...lg.firstWord.length
      assert_equal lg.firstWord[i], lg.grid[lg.fwX][lg.fwY+i], "letter " + i.to_s + " of word " + lg.firstWord + " isn't at the right place"
    end
  end

  test "function found? finds first word" do
    p1 = Player.new(name: "Georges")
    p2 = Player.new(name: "Georginette")
    g = Game.new({:size => 5, :dictionary => "anglais.txt", :players => [p1, p2]})
    p1.save()
    p2.save()
    g.save()
    lg = Game.where(:firstWord => g.firstWord)[0]
    for i in 0...lg.firstWord.length
      assert lg.found?(lg.firstWord[i], lg.firstWord, lg.fwX, lg.fwY+i), "first word is not found"
    end
  end

  test "can save a move" do
    p1 = Player.new(name: "Georges")
    score = p1.totalScore
    p2 = Player.new(name: "Georginette")
    g = Game.new({:size => 5, :dictionary => "anglais.txt", :players => [p1, p2]})
    g.saveMove(p1, 'e', "error", 0, 4)
    assert g.grid[0][4] == 'e', "letter isn't inserted in grid"
    assert_equal p1.totalScore, score+5, "player's score isn't updated"
  end
end
