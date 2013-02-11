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
      flash[:isStarted]=true
      session[:challenger] = @challenger
      redirect_to :action=>'start'
    end
  end
  
  def start
    @p1=session[:player]
    @p2=session[:challenger]
    @size=(params[:size]==nil || params[:size].to_i>10 || params[:size].to_i<5)? 5: params[:size].to_i;
   
    @countGames=Game.where("players.name = ? and finished =?",session[:player].name,false).includes(:players).count
    if(flash[:isStarted])
      @game=Game.find(session[:current_game])
      flash[:isStarted]=true
       
    elsif(@countGames>5)
      flash[:error]="You have already 5 started games"
      redirect_to :action=>'menu', :controller=>'menu'
    elsif(@p1!=nil && @p2!=nil)
      @game=Game.create(:size=>@size, :dictionary=>"anglais.txt", :players=>[@p1,@p2])      
      session[:current_game]=@game.id   
      flash[:isStarted]=true
    else
      redirect_to :action=>'index', :controller=>'players'
      
    end
  end
  
  #for ajax call from the view when a new word is inserted
  def submit_word
    @word=params[:word]
    @letter=params[:letter]
    @game=Game.find(session[:current_game])
    @player=session[:player]
    @x=params[:x].to_i
    @y=params[:y].to_i
    puts @game.found?(@letter,@word,@x,@y)
    if(@word && @letter&& @game&&@player&&@x&&@y)        
      if(!@game.already_played?(@word)&&@game.authorized?(@letter,@word,@x,@y)&&@game.found?(@letter,@word,@x,@y))
        @game. saveMove(@player, @letter, @word,@x,@y)
       
        respond_to do |format|
          format.js { render :json => {"ok" => true, "finished" => @game.finished?}}
        end
      else
        respond_to do |format|
          format.js { render :json => {"ok" => false}}
        end  
      end
    else
      throw Exception.new "there is a nil parameter"      
    end
  end

  def pass
    @game=Game.find(session[:current_game])
    @game.pass_turn
    
    if (@game.finished?)
      respond_to do |format|
        format.js { render :json => true }
      end
    else
      respond_to do |format|
        format.js { render :json => false }
      end
    end
  end

  def show_played_words
    
    @game=Game.find(session[:current_game])
  end
  
  def proposed_games
    if(session[:player])
      @games= Game.where("players.name = ? AND finished=?",session[:player].name,false ).includes(:players)
      #@games=Game.find(:all)
     
      @name=session[:player].name
     
    else
      flash[:error]="You're not signed in!"
      redirect_to :action=>"index", :controller=>"menu" 
    end
   
  end
  
  def refresh_grid
    @game=Game.find(session[:current_game])  
      
    if(@game.playedWords.length<1)
      @turn= (@game.players[0].name==session[:player].name)
     
    else
      @turn=(session[:player].name!=@game.playedWords[-1].player.name)
      if(@game!=nil &&@game.pass?)
        @turn=!@turn
      end
    end
    respond_to do |format|
      # puts @game.playedWords.as_json(:only=>:word,:include => { :player => { :only => :name }})
      # format.js {   render :json => @game.grid}
  
     
      format.js {   render :json => {"result"=>@game.playedWords.as_json(:include=>:word,:include => { :player => { :only => :name }}),"grid"=>@game.grid,"turn"=>@turn,"finished"=>@game.finished?}}
    end
  end
  
  def refresh_result
    @game=Game.find(session[:current_game])    
    
    respond_to do |format|
     
      format.js {   render :json => {"result"=>@game.playedWords.as_json(:only=>:word,:include => { :player => { :only => :name }}),"grid"=>@game.grid}}
    end  
  end
  def winner
    @game=Game.find(session[:current_game])    
    s1 = 0
    s2 = 0
    for pw in @game.playedWords
      if (pw.player == @game.players[0])
        s1 += pw.word.length
      else
        s2 += pw.word.length
      end
    end
    if (s1 > s2)
      @name=@game.players[0].name
    elsif (s1 < s2)
      @name=@game.players[1].name
    end
    respond_to do |format|
     
      format.js {   render :json =>{"name"=>@name }}
    end  
  end
end
