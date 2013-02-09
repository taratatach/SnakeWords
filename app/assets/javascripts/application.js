// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require jquery-ui.min


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
    $("#target"+i+"."+j).css("background-color","blue");
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
alert('Load was performed.');
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
     $('#target0.0').fadeOut("slow").load('/game/start #target0.0').fadeIn("fast");
}, 1000);