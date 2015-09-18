require 'csv'

task import: :environment do

  @brand_mappings = {
    'avian science super diet ' => 'avian-science',
    'single seed' => nil,
    'wild bird' => 'volkman-wild-bird',
    'caged bird products' => nil,
    'premium wild bird' => 'premium-wild-bird',
    "bird's delight" => 'birds-delight',
    'featherglow  diets ' => 'featherglow',
    "nature's feast vitamized" => 'natures-feast',
    'small animal' => 'small-animal',
    'petamine' => 'petamine',
    'pigeon' => nil,
    'loft' => nil,
    'bedding' => nil
  }
  def brands_for str
    raise "Could not find brand for '#{str}'" unless @brand_mappings.key?(str)
    taxon = @brand_mappings[str]
    return [] if taxon.nil?
    return taxon if taxon.is_a?(Array)
    @brand_mappings[str] = [Spree::Taxon.friendly.find("brands/#{taxon}")]
  end

  def property_for name, presentation
    Spree::Property
      .where(name: name)
      .create_with(presentation: presentation)
      .first_or_create!
  end
  @properties = {
    analysis: property_for('analysis', 'Analysis'),
    additives: property_for('additives', 'Additives'),
    directions: property_for('directions', 'Directions'),
    ingredients: property_for('ingredients', 'Ingredients')
  }
  def product_property_for name, value
    if value.present?
      Spree::ProductProperty.new(
        property: @properties[name],
        value: value)
    end
  end

  def option_type_for name, presentation
    Spree::OptionType
      .where(name: name)
      .create_with(presentation: presentation)
      .first_or_create!
  end
  @option_types = {
    size: option_type_for('size', 'Size')
  }

  def image_for filename
    filename = File.expand_path(filename, ENV['images'])
    Spree::Image.new(attachment: File.open(filename))
  end

  def product_for sku
    Spree::Variant.find_by(sku: sku).try(:product) ||
      Spree::Product.new(sku: sku)
  end

  def normalize_weight weight
    number = weight[/\./] ? weight.to_f : weight.to_i
    case weight.downcase
    when /oz/    then "#{number} ounces"
    when /#|lb/  then "#{number} pounds"
    when /caps/  then "#{number} caps"
    when /pills/ then "#{number} pills"
    else raise "Could not normalize weight: '#{weight}'"
    end
  end

  rows = CSV.table(File.expand_path(ENV['csv'])).send(:table)
  rows.select!{|row| row[:birdseedcom] == 'x' }
  products = rows.group_by{|row| row[:product_grouping] }
  shipping = Spree::ShippingCategory.find_or_create_by!(name: 'Default')

  puts "Processing #{products.length} products"

  ActiveRecord::Base.transaction do
    products.each_value.with_index do |variants, index|
      begin
        master = variants.first
        has_variants = variants.length > 1
        product = product_for(master[:product_code])
        unless ENV['skip_product']
          product.update!(
            sku: (has_variants ? '' : master[:product_code]),
            name: master[:item_name],
            description: master[:item_description],
            taxons: brands_for(master[:category]),
            option_types: (has_variants ? [@option_types[:size]] : []),
            available_on: Time.now,
            price: 1,
            shipping_category: shipping,
            product_properties: [
              product_property_for(:directions, master[:directions]),
              product_property_for(:analysis, master[:analysis]),
              product_property_for(:additives, master[:nutritional_additives]),
              product_property_for(:ingredients, master[:ingredients])
            ].compact)
        end
        if has_variants && !ENV['skip_variants']
          product.update!(variants: variants.map do |variant|
            weight = normalize_weight(variant[:weight])
            Spree::Variant.create!(
              sku: variant[:product_code],
              product: product,
              option_values: [
                Spree::OptionValue
                  .where(option_type: @option_types[:size], name: weight)
                  .create_with(presentation: weight)
                  .first_or_create!
              ])
          end)
        end
        unless ENV['skip_images']
          product.master.update!(images: variants
            .map { |variant| variant[:'1000px_image_name'] }
            .reject(&:blank?)
            .map { |filename| image_for(filename) })
        end
        print "\r#{index * 100 / products.length}%"
      rescue => e
        byebug
      end
    end
  end
end
