class ShopController < Spree::StoreController

  def index
    load_products_for(taxon: 'specials')
  end

  def birds
    @birds = Spree::Taxon.friendly.find('birds').children
    if @bird = params[:bird]
      load_products_for(taxon: "birds/#{@bird}")
    end
  end

  def brands
    @brands = Spree::Taxon.friendly.find('brands').children
    if @brand = params[:brand]
      load_products_for(taxon: "brands/#{@brand}")
    end
  end

  def search
    if (@query = params[:query]).present?
      load_products_for(query: @query)
    end
  end

  private

  def load_products_for taxon: nil, query: nil
    searcher_params = params.merge(include_images: true)
    searcher_params.merge!(taxon: Spree::Taxon.friendly.find(taxon).id) if taxon
    searcher_params.merge!(keywords: query) if query
    searcher = build_searcher(searcher_params)
    @products = searcher.retrieve_products
  end

end
