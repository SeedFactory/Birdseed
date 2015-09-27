Spree::HomeController.class_eval do
  def index
    @featured_items = Spree::FeaturedItem.active.ordered
  end
end
