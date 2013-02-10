

function pass() {
    $.ajax(
    {
        url:"/game/pass",
        data:{},
        cache:false,
        dataType:"json",
        success:function(finished) {
            if(finished){
		end_game();
            }
            else{
		// le jeu n'est pas fini, le joueur est le premier à passer
		alert("You have passed");
            }
        },
        error:function(xhr,status,error) {
            alert(error);
        }
    });
}

function end_game() {
    // la grille est pleine, le jeu est fini
    alert("Game is finished");
   window.location.replace("/menu/menu");  
    
}

function word(i,j){
        $("#dialog" ).css('display','block') ;
        $("#submit").attr('onclick',"submit_form("+i+","+j+")");
        
  //  $( "#dialog" ).data('id',""+i+"."+j).dialog( "open" ); 
   
}
  function submit_form(i,j) {
                var letter= $('#letter').val(); 
                var word= $('#given_word').val(); 
                if(word==""||letter==""){
                 alert("Empty field is not allowed!")   
                 
                }else{
                var cellId=i+"."+j
                send(letter,cellId,word);     
                $('#letter').val(""); 
                $('#given_word').val(""); 
                
                 $( "#dialog" ).css('display','none') ;
                }
            }
            
  /*          function submit() {
                var letter= $('#letter').val(); 
                var word= $('#word').text(); 
                var cellId=$(this).data('id');
                send(letter,cellId,word);              
                 $('#letter').val("");
                 $('#word').text(""); 
                 $( "#dialog" ).css('display','block') ;
            }*/

function send(letter,cellId,word){
    $.ajax(
    {
        url:"/game/submit_word",
   
        data:{
            word:word,
            letter:letter,
            x:cellId.split(".")[0],
            y:cellId.split(".")[1]
     
        },
        cache:false,
        dataType:"json",
        success:function(result){
            if (result.finished) {
		end_game();
	    } else if(result.ok) {
                document.getElementById("target"+cellId).innerHTML=letter;
		
            }
            else {
                alert("The word doesn't exist in the dictionnary or is not in the grid");
            }
        }
        ,
        error:function(xhr,status,error)
        {
            alert(error);
        }
    });
}

var refreshId = setInterval(function()
{
    $.ajax(

    {
            url:"/game/refresh_grid",   
            data:{
               
            },
            cache:false,
            dataType:"json",
            success:function(result){
                
                
               
                if(result){ 
                   // checks the turn
                   if(result.finished){
                      
                       end_game();
                       return;
                   }
                   if(!result.turn){
                        $( "#turn" ).css('display','none') ;
                        $("#pass").prop('disabled', true);
                        $("#submit").prop('disabled', true);
                   }
                   else{
                       $( "#turn" ).css('display','block') ;
                        $("#pass").prop('disabled', false);
                        $("#submit").prop('disabled', false);
                   }
                     //grid refresh
                     var emptyCells=0;
                    for(var i=0;i<result.grid.length;i++){
                        for(var j=0;j<result.grid.length;j++){
                            if(result.grid[i][j]!=null){
                                
                            var ele= document.getElementById("target"+i+"."+j)
                            ele.innerHTML=result.grid[i][j]; 
                            ele.removeAttribute("onclick");
                          
                            }else{
                                emptyCells+=1;
                            }
                        } 
                    }
                 //played words refresh
                 if(parseInt($('#resultTable').attr('size'))<result.result.length){
                   $('#resultTable').attr('size',parseInt($('#resultTable').attr('size'))+1);
                   var table= document.getElementById("resultTable");
                     table.innerHTML=resultHtml(result.result);  
                     
                 }
                 if(emptyCells==0){
                     
                     end_game();
                 }
                }
                else{
                    alert("Something went wrong while tryin to refresh")
                }
            }
            ,
            error:function(xhr,status,error)
            {
                alert(error);
            }
        });
     
}, 3000);

function resultHtml(result) {
 var res='';
  res+='<div class="thead" ><span>Player</span><span>Word</span><span>score</span></div>'
  for(var i=0;i<result.length;i++){
      res+='<div id="row" >'
      res+= '<span id="name"'+i+'>'+result[i].player.name+'</span>';
      res+='<span id="word"'+i+'>'+result[i].word+'</span>';
      res+='<span id="score"'+i+'>'+result[i].word.length+'</span>';
      res+='</div>'
  }
  
  return res;
  
}


function closeNow(){
   
     $( "#dialog" ).css('display','none') ;
}

function myTurn(){
    
}
