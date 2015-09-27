Deface::Override.new(
  virtual_path: 'spree/admin/shared/_main_menu',
  name: 'add_featured_items_to_main_menu',
  insert_after: 'erb[silent]:nth-child(6)',
  text: <<-HTML.strip_heredoc
    <% if can? :admin, Spree::FeaturedItem %>
      <ul class="nav nav-sidebar">
        <%= tab :featured_items, url: spree.admin_featured_items_path, icon: 'flash' %>
      </ul>
    <% end %>
  HTML
  )
