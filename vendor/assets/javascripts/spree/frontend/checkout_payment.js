(function() {

  function updateDisabled(instant) {
    var checked = $('.checkout-payment-saved-cards :radio:checked');
    var action = checked.attr('value') ? 'slideUp' : 'slideDown';
    $('.checkout-payment-new-card')[action](instant ? 0 : 250);
  }

  $(document).on('change', '.checkout-payment-number', function() {
    $('.checkout-payment-cc-type').val($.payment.cardType(this.value));
  });
  $(document).on('change', '.checkout-payment-saved-cards :radio', function() {
    updateDisabled(false)
  });
  $(document).on('page:change', function() {
    updateDisabled(true);
    $('.checkout-payment-number').payment('formatCardNumber');
    $('.checkout-payment-verification-value').payment('formatCardCVC');
  });

})();
