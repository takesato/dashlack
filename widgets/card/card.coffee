class Dashing.Card extends Dashing.Widget
 onData: (data) ->
   if data.presence
      $(@node).css('background-image', "url('" + data.img + "')");
   else
      $(@node).css('background-image', "");
