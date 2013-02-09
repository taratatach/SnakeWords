class GameController < ApplicationController
  def new_game 
    @p2=Player.find_by_name(params[:id])
    if (@p2!=nil)
      session[:challenger] = @p2
    else
      redirect_to :action=>'new_game'
    end
    
  end
  def join_game
    @game=Game.find(params[:id])
    @challenger=nil
    @game.players.each do |p|
      @challenger=(p.name!=session[:player].name)? p : @challenger
      
    end
    
    if(@challenger) 
      session[:current_game]=@game.id
      params[:isStarted]=true
      session[:challenger] = @challenger
      redirect_to :action=>'start'
    end
  end
  
  def start
    @p1=session[:player]
    @p2=session[:challenger]
    @size=(params[:size]==nil || params[:size].to_i>10 || params[:size].to_i<5)? 5: params[:size].to_i;
    if(params)
      @game=Game.find(session[:current_game])
      puts "i did the find"
    elsif(@p1!=nil && @p2!=nil)
        @game=Game.create(:size=>@size, :dictionary=>"anglais.txt", :players=>[@p1,@p2])      
        session[:current_game]=@game.id      
    else
        redirect_to :action=>'index', :controller=>'players'
      
    end
  end
  
    #for ajax call from the view 
    def submit_word
      @word=params[:word]
      @letter=params[:letter]
      @game=Game.find(session[:current_game])
      @player=session[:player]
      if(@word && @letter&& @game&&@player)         
        @game. saveMove(@player, @letter, @word, params[:x].to_i,params[:y].to_i)
      end
      respond_to do |format|
        format.js { render :json => true }
      end
    end
  
    def show_played_words
      @game=Game.find(session[:current_game])
    end
  
    def proposed_games
      @games= Game.where("players.name <= ?",session[:player].name ).includes(:players)
    end
  
end