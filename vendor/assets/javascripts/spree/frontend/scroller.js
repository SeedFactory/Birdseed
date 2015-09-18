$(document).on('page:change', function() {
  $(window).off('resize.scroller');
  var container = $('[data-scroller-container]');
  if(!container.length) {
    return;
  }
  var scroller = container.find('[data-scroller]');
  scroller.on('scroll', updateDirection);
  $(window).on('resize.scroller', updateDirection);
  updateDirection();
  function updateDirection() {
    var scroll = scroller.scrollLeft();
    var buffer = 50;
    var left = scroll > buffer;
    var right = scroller[0].scrollWidth - $(window).width() - scroll > buffer;
    var direction = left ? (right ? 'both' : 'left') : (right ? 'right' : 'none');
    container.attr('data-scroller-direction', direction);
  }
  container.find('[data-scroller-left]').on('click touchstart', function() {
    scroller.find('[data-scroller-target]').each(function() {
      var position = -$(this).position().left;
      if(position > 0 && position - 2 < $(this).outerWidth(true)) {
        scroller.animate({ scrollLeft: '-=' + position }, position);
        return false;
      }
    });
  });
  container.find('[data-scroller-right]').on('click touchstart', function() {
    var offset = $(window).width();
    scroller.find('[data-scroller-target]').each(function() {
      var position = $(this).position().left;
      if(position < offset && position + $(this).outerWidth(true) > offset) {
        scroller.animate({ scrollLeft: '+=' + position }, position);
        return false;
      }
    });
  });
});
