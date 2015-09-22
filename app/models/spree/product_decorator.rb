Spree::Product.class_eval do

  def brand
    @brand ||= taxons.find_by(taxonomy: Spree::Taxonomy.where(name: 'Brands'))
  end

end
