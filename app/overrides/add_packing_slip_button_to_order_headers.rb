text = <<-HTML
<% if can? :packing_slip, @order %>
  <%= button_link_to 'Packing Slip', packing_slip_admin_order_url(@order),
    icon: 'file' %>
<% end %>
HTML

Deface::Override.new(
  virtual_path: 'spree/admin/orders/cart',
  name: 'add_packing_slip_to_orders_cart_header',
  insert_after: 'erb[silent]:nth-child(1)',
  text: text)

Deface::Override.new(
  virtual_path: 'spree/admin/orders/edit',
  name: 'add_packing_slip_to_orders_edit_header',
  insert_after: 'erb[silent]:nth-child(1)',
  text: text)
