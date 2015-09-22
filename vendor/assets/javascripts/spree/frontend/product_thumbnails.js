$(document).on('click', '.product-images-thumbnails a', function(event) {
  event.preventDefault();
  var query = '(min-resolution: 100dpi)';
  var high_dpi = window.matchMedia && matchMedia(query).matches;
  var attr = high_dpi ? 'high-dpi-image' : 'low-dpi-image';
  $('.product-image').css('backgroundImage', 'url(' + $(this).data(attr) + ')');
});
