Deface::Override.new(
  virtual_path: 'spree/admin/product_properties/_product_property_fields',
  name: 'change_product_property_value_to_textarea',
  replace: 'td.value erb',
  text: "<%= f.text_area :value, class: 'form-control' %>")
