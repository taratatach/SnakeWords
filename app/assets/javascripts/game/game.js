


function word(i,j){
        $("#dialog" ).css('display','block') ;
        $("#submit").attr('onclick',"submit_form("+i+","+j+")");
        
  //  $( "#dialog" ).data('id',""+i+"."+j).dialog( "open" ); 
   
}
  function submit_form(i,j) {
                var letter= $('#letter').val(); 
                var word= $('#given_word').val(); 
                var cellId=i+"."+j
                send(letter,cellId,word);     
                $('#letter').val(""); 
                $('#given_word').val(""); 
                
                 $( "#dialog" ).css('display','none') ;
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
            x:cellId[0],
            y:cellId[2]
     
        },
        cache:false,
        dataType:"json",
        success:function(result){
            if(result){
                document.getElementById("target"+cellId).innerHTML=letter;
//                $('#result').load('/game/show_played_words #result', function() {                 
//              });
//                
            }
            else{
                alert("The word doesn't exist in the dictionnary or is not in the grid")
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
                //grid refresh
                if(result){ 
                    for(var i=0;i<result.grid.length;i++){
                        for(var j=0;j<result.grid.length;j++){
                            document.getElementById("target"+i+"."+j).innerHTML=result.grid[i][j];                    
                        } 
                    }
                 //played words refresh
                 if(parseInt($('#resultTable').attr('size'))<result.result.length){
                   $('#resultTable').attr('size',parseInt($('#resultTable').attr('size'))+1);
                   var table= document.getElementById("resultTable");
                     table.innerHTML=resultHtml(result.result);  
                     
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
     
}, 5000);

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