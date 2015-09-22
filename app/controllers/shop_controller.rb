class ShopController < Spree::StoreController

  def index
    @products = products_for(taxon: taxon_for('specials'))
  end

  def birds
    @birds = taxon_for('birds').children
    if @bird = params[:bird]
      @bird = taxon_for("birds/#{@bird}")
      @products = products_for(taxon: @bird)
    end
  end

  def brands
    @brands = taxon_for('brands').children
    if @brand = params[:brand]
      @brand = taxon_for("brands/#{@brand}")
      @products = products_for(taxon: @brand)
    end
  end

  def search
    if (@query = params[:query]).present?
      @products = products_for(search: {
        name_or_description_or_taxons_name_cont: @query
      }).uniq
    end
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
