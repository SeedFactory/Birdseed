class OrdersController < Spree::BaseController

  def index
    if spree_current_user
      @orders = spree_current_user.orders.complete
    else
      redirect_to spree.shop_path
    end
  end

end
