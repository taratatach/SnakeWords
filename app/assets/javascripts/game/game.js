
$(function() {
    $( "#dialog" ).dialog({
        autoOpen: false,
        position: "left",
     
        modal: true,
        buttons: {
            "submit": function() {
                var letter= $('#letter').val(); 
                var word= $('#word').val(); 
                var cellId=$(this).data('id');
                submit(letter,cellId,word);
                $( this ).dialog( "close" );
            }
        }
       
    });


		
});


function word(i,j){
       
    $( "#dialog" ).data('id',""+i+"."+j).dialog( "open" ); 
   
}
function submit(letter,cellId,word){
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
                $('#result').load('/game/show_played_words #result', function() {
                   
                });
                
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
                if(result){ 
                    for(var i=0;i<result.length;i++){
                        for(var j=0;j<result.length;j++){
                            document.getElementById("target"+i+"."+j).innerHTML=result[i][j];                    
                        } 
                    }
                  //   $('#result').load('/game/show_played_words #result', function() {        
               // });
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