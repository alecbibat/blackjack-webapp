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

$(document).ready(function(){
  $('form#stay_button input').click(function(){
    $(document).on('click', 'form#stay_button input', function(){
      $.ajax({
        type: 'POST',
        url: '/game/player/stay',
      }).done(function(msg){
        $('#game').replaceWith(msg)
      });
      return false;
    });
  });
});

$(document).ready(function(){
  $('form#dealer_hit_button input').click(function(){
    $(document).on('click', 'form#dealer_hit_button input', function(){
      $.ajax({
        type: 'POST',
        url: '/dealer/hit',
      }).done(function(msg){
        $('#game').replaceWith(msg)
      });
      return false;
    });
  });
});