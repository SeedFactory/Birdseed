$(document).on('click touchstart', '.birdseed-nav-toggle', function(event) {
  event.preventDefault();
  $('html').toggleClass('birdseed-nav-toggled');
});

$(document).on('page:before-change', function() {
  $('html').removeClass('birdseed-nav-toggled');
});
