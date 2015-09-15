(function() {

function isChecked() {
  return $('#order_use_billing').is(':checked');
}

function fadeShippingAddress() {
  var action = isChecked() ? 'slideUp' : 'slideDown';
  $('#shipping_address_fields')[action](250);
}

function hideShippingAddress() {
  if(isChecked()) {
    $('#shipping_address_fields').hide();
  }
}

$(document).on('change', '#order_use_billing', fadeShippingAddress);
$(hideShippingAddress);

})();
