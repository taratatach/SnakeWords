class MenuController < ApplicationController
  
  def index    
  end
  

    def signin
      @p=Player.find_by_name(params[:name])
      if(@p==nil)
        flash[:error]="Wrong player name"
        redirect_to :action=>index
      else
        session[:player]=@p
        redirect_to :action=>'menu'
       
      end
      
    end
    def signout
     session[:player]=nil;
      
        redirect_to :action=>'menu'
     
      
    end
    
    def menu
      if(!session[:player])
        flash[:error]="You're not signed in!"
        redirect_to :action=>'index'
      end
    end
    def pick_challenger
      redirect_to :action=>'index', :controller=>'players'      
    end
    
    def proposed_games
      redirect_to :action=>'proposed_games', :controller=>'game'  
    end
    
    def high_score
      
      @players=Player.find(:all,:order=>"totalScore DESC",  :limit => 5)
      if(!@players)
        flash[error]="no player in the database"
        redirect_to :action=>"index" 
        
      end

    end
  
end