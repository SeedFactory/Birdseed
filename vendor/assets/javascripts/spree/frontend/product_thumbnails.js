$(document).on('click', '.product-images-thumbnails a', function(event) {
  event.preventDefault();
  $('.product-image').attr('src', $(this).data('full-image'));
});
