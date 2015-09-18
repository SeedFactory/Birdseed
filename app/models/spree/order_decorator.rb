Spree::Order.class_eval do
  state_machine do
    after_transition to: :delivery do |order|
      if order.shipments.all? { |shipment| shipment.shipping_rates.count == 1 }
        order.shipments.each do |shipment|
          shipment.selected_shipping_rate_id = shipment.shipping_rates.first.id
        end
        order.next
      end
    end
  end
end
