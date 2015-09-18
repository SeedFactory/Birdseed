$(document).on('page:change', function() {
  var active = $('.shop-nav-taxon.active');
  if(active.length) {
    var scroller = active.closest('.shop-nav-taxons-scroller');
    var padding = parseFloat(scroller.css('padding-left'));
    var offset = active.position().left - padding;
    scroller.scrollLeft(offset);
  }
});
