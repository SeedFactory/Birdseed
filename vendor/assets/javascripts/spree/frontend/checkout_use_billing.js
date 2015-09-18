(function() {

function isChecked() {
  return $('.checkout-address-use-billing').is(':checked');
}

function fadeShippingAddress() {
  var action = isChecked() ? 'slideUp' : 'slideDown';
  $('.checkout-address-shipping-fields')[action](250);
}

function hideShippingAddress() {
  if(isChecked()) {
    $('.checkout-address-shipping-fields').hide();
  }
}

$(document).on('change', '.checkout-address-use-billing', fadeShippingAddress);
$(document).on('page:change', hideShippingAddress);

})();
