Deface::Override.new(
  virtual_path: 'spree/layouts/spree_application',
  name: 'remove_container_from_content',
  replace: 'body > .container',
  text: '<%= yield %>')