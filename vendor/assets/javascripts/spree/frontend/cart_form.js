$(document).on('change', 'form.cart select', function() {
  $(this).closest('form').submit();
});
