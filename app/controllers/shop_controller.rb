class ShopController < Spree::StoreController

  def index
    if (@products = specials).none?
      redirect_to app_url_helpers.shop_birds_path, turbolinks: true
    end
  end

  def birds
    @birds = taxons_for('Birds')
    if @bird = params[:bird]
      @bird = taxon_for("birds/#{@bird}")
      @products = products_for(taxon: @bird)
    end
  end

  def brands
    @brands = taxons_for('Brands')
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

  def taxons_for name
    Spree::Taxonomy.find_by(name: name).taxons.order(:name)
  end

end
