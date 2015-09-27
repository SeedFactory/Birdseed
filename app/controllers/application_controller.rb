class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :app_url_helpers, :specials

  def app_url_helpers
    Rails.application.routes.url_helpers
  end

  def specials
    @specials ||= products_for(taxon: taxon_for('specials'))
  end

  private

  def taxon_for permalink
    Spree::Taxon.friendly.find(permalink)
  end

  def products_for taxon: nil, search: nil
    searcher_params = params.merge(include_images: true)
    searcher_params.merge!(taxon: taxon.id) if taxon
    searcher_params.merge!(search: search) if search
    searcher = build_searcher(searcher_params)
    searcher.retrieve_products
  end

end
