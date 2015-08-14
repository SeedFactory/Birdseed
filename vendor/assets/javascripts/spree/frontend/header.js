$(function() {

  var header = $('.birdseed-header');

  $(window).on('scroll', function() {
    if (window.scrollY > 0) {
      header.addClass('stuck');
    } else {
      header.removeClass('stuck');
    }
  });

});
