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

  test "pass_turn function changes pass state in db" do
    p1 = Player.new(name: "Georges")
    p2 = Player.new(name: "Georginette")
    g = Game.new({:size => 5, :dictionary => "anglais.txt", :players => [p1, p2]})
    assert !g.pass?, "pass is already set to true"
    g.pass_turn
    assert g.pass?, "pass_turn doesn't set pass to true"
  end

  test "two calls to pass_turn ends game" do
    p1 = Player.new(name: "Georges")
    p2 = Player.new(name: "Georginette")
    g = Game.new({:size => 5, :dictionary => "anglais.txt", :players => [p1, p2]})
    g.pass_turn
    g.pass_turn
    assert g.finished?, "game isn't set as finished"
  end

  test "a call to saveMove after a call to pass_turn toggle back pass to false" do
    p1 = Player.new(name: "Georges")
    p2 = Player.new(name: "Georginette")
    g = Game.new({:size => 5, :dictionary => "anglais.txt", :players => [p1, p2]})
    g.pass_turn
    assert g.pass?, "pass_turn doesn't set pass to true"
    g.saveMove(p2, "e", "ever", 0, 0)
    assert !g.pass?, "saveMove doesn't set pass to false"
  end

  test "a full grid ends the game" do
    p1 = Player.new(name: "Georges")
    p2 = Player.new(name: "Georginette")
    g = Game.new({:size => 5, :dictionary => "anglais.txt", :players => [p1, p2]})
    for i in 0...g.size
      for j in 0...g.size
        if (g.grid[i][j] == nil)
          g.saveMove(p2, "a", "a", i, j)
        end
      end
    end
    assert g.finished?, "finished is not true when the grid is full"
  end

  test "ending game sets victor" do
    p1 = Player.new(name: "Georges")
    p2 = Player.new(name: "Georginette")
    assert_equal p2.totalWins, 0, "player already has victories"
    g = Game.new({:size => 5, :dictionary => "anglais.txt", :players => [p1, p2]})
    g.saveMove(p2, "e", "ever", 0, 0)
    g.end_game
    assert_equal p2.totalWins, 1, "player's victories isn't incremented by end_game"
  end

  test "can't play twice the same word" do
    p1 = Player.new(name: "Georges")
    p2 = Player.new(name: "Georginette")
    g = Game.new({:size => 5, :dictionary => "anglais.txt", :players => [p1, p2]})
    assert g.already_played?(g.firstWord), "can play the first inserted word"
    g.saveMove(p1, "e", "ever", 0, 0)
    assert g.already_played?("ever"), "can play twice the same word"
    assert !g.already_played?("bonjour"), "bonjour is detected as already played"
  end
end
