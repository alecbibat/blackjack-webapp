$(document).ready(function(){
  $('form#hit_button input').click(function(){
    $(document).on('click', 'form#hit_button input', function(){
      $.ajax({
        type: 'POST',
        url: '/game/player/hit',
      }).done(function(msg){
        $('#game').replaceWith(msg)
      });
      return false;
    });
  });
});