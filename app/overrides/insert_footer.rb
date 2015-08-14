Deface::Override.new(
  virtual_path: 'spree/layouts/spree_application',
  name: 'insert_footer',
  insert_after: '.container',
  partial: 'spree/shared/footer')