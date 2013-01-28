class MenuController < ApplicationController
  
  def index
    
  end
  
  def new_game
    @game=Game.new
    @p1=Player.new("amha")
    @p2=Player.new("Erwan")
    @game.players.push(@p1,@p2)
       
  end
end
