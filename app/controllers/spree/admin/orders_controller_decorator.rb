Spree::Admin::OrdersController.class_eval do

  before_action :load_order, only: :packing_slip

  def packing_slip
    render layout: false
  end

end
