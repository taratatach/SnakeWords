class PlayersController < ApplicationController
  def  index
   @players=Player.find(:all)
  end
  
  def create
    @player=Player.new(params[:name])
    
  
    if @player.save
      redirect_to :action=>"index"
    else
      redirect_to :action=>"new"      
    end
    
  end
  
  def new
    
  end
  
  
end
