class MenuController < ApplicationController
  
  def index    
  end
  

    def signin
      @p=Player.find_by_name(params[:name])
      if(@p==nil)
        flash[:alert]="Wrong player name"
        redirect_to :action=>index
      else
        session[:player]=@p
        redirect_to :action=>'menu'
       
      end
      
    end
    
    def menu
      
    end
    def pick_challenger
      redirect_to :action=>'index', :controller=>'players'      
    end
    
    def proposed_games
      redirect_to :action=>'proposed_games', :controller=>'game'  
    end
  
end