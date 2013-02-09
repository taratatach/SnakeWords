class GameController < ApplicationController
  def new_game 
    @p2=Player.find_by_name(params[:id])
    if (@p2!=nil)
      session[:challenger] = @p2
    else
      redirect_to :action=>'new_game'
    end
    
  end
  
  def start
    @p1=session[:player]
    @p2=session[:challenger]
    @size=(params[:size]==nil || params[:size].to_i>10 || params[:size].to_i<5)? 5: params[:size].to_i;
    
    if(@p1!=nil && @p2!=nil)
      @game=Game.new
      @game.init(@size,"anglais.txt",[@p1,@p2])
      @game.save
      session[:current_game]=@game.id
      
    else
      redirect_to :action=>'index', :controller=>'players'
    end
  end
  def submit_word
    @word=params[:word]
    @letter=params[:letter]
    @game=Game.find(session[:current_game])
    @player=session[:player]
    if(@word && @letter&& @game&&@player)     
       
       @game. saveMove(@player, @letter, @word, 1, 2)
    end
    respond_to do |format|
      format.js { render :json => true }
    end
  end
end


  