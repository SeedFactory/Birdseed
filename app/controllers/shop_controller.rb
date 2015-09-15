class ShopController < Spree::StoreController

  def index
    load_products_for(taxon: taxon_for('specials'))
  end

  def birds
    if @bird = params[:bird]
      @bird = taxon_for("birds/#{@bird}")
      load_products_for(taxon: @bird)
    else
      @birds = taxon_for('birds').children
    end
  end

  def brands
    if @brand = params[:brand]
      @brand = taxon_for("brands/#{@brand}")
      load_products_for(taxon: @brand)
    else
      @brands = taxon_for('brands').children
    end
  end

  def search
    if (@query = params[:query]).present?
      load_products_for(query: @query)
    end
  end

  private

  def taxon_for permalink
    Spree::Taxon.friendly.find(permalink)
  end

  def load_products_for taxon: nil, query: nil
    searcher_params = params.merge(include_images: true)
    searcher_params.merge!(taxon: taxon.id) if taxon
    searcher_params.merge!(keywords: query) if query
    searcher = build_searcher(searcher_params)
    @products = searcher.retrieve_products
  end

end
