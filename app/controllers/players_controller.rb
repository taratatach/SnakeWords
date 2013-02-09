class PlayersController < ApplicationController
  def  index
   @allPlayers=Player.find(:all)
   @players=[]
   for player in @allPlayers
     if(player.name != session[:player].name)
       @players.push(player)
     end
   end
  end
  
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