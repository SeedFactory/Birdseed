class ShopController < Spree::StoreController

  def index
    if (@products = specials).none?
      redirect_to app_url_helpers.shop_birds_path, turbolinks: true
    end
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

end
