#author: Amha Bekele
#this controller is in charge of actions concerning players of the game
class PlayersController < ApplicationController
  
  #list of all players expect the current player stored in session
  def  index
   
    if(!session[:player])
   
      flash[:error]="You're not signed in!"
      redirect_to :action=>"index", :controller=>"menu"
    else
   @allPlayers=Player.find(:all)
   @players=[]
   for player in @allPlayers
     if(player.name != session[:player].name)
       @players.push(player)
     end
   end
    end
  end
  #creates a new player profile
  def create
    @player=Player.create(:name=>params[:name])
    
  
    if @player.save
       flash[:notice]="#{params[:name]} is now part of the SnakeWords world"
      redirect_to :action=>"index",:controller=>"menu"
    else
       flash[:alert]="This player name is already used"
      redirect_to :action=>"new"      
    end
    
  end
  
  def new
    
  end
  
  
end