$(function() {

$('.checkout-payment-number').payment('formatCardNumber');
$('.checkout-payment-verification-value').payment('formatCardCVC');

$('.checkout-payment-number').on('change', function() {
  $('.checkout-payment-cc-type').val($.payment.cardType(this.value));
});

function updateDisabled(instant) {
  var checked = $('.checkout-payment-saved-cards :radio:checked');
  var action = checked.attr('value') ? 'slideUp' : 'slideDown';
  $('.checkout-payment-new-card')[action](instant ? 0 : 250);
}

$('.checkout-payment-saved-cards :radio').on('change', function() {
  updateDisabled(false)
});
updateDisabled(true);

});
