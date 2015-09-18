Spree::OrdersHelper.module_eval do

  def attrs_for_nav state
    attrs = ''
    if @order.state == state
      attrs << " class='active'"
    end
    if @order.passed_checkout_step?(state)
      attrs << " href='#{checkout_state_path(state)}'"
    end
    attrs.html_safe
  end

end