require 'csv'

task import: :environment do

  @brand_mappings = {
    'avian science super diet' => 'avian-science',
    'single seed' => nil,
    'wild bird' => 'volkman-wild-bird',
    'caged bird products' => nil,
    'premium wild bird' => 'premium-wild-bird',
    "bird's delight" => 'birds-delight',
    'featherglow diets' => 'featherglow',
    "nature's feast vitamized" => 'natures-feast',
    'small animal' => 'small-animal',
    'petamine' => 'petamine',
    'pigeon' => nil,
    'loft' => nil,
    'bedding' => nil,
    'henny penny' => 'henny-penny',
    'oropharma' => 'oropharma',
    'colombine' => 'colombine',
    'versele-laga' => 'versele-laga',
    'orlux' => 'orlux'
  }
  def brands_for str
    str = str.downcase
    raise "Could not find brand for '#{str}'" unless @brand_mappings.key?(str)
    taxon = @brand_mappings[str]
    return [] if taxon.nil?
    return taxon if taxon.is_a?(Array)
    @brand_mappings[str] = [Spree::Taxon.friendly.find("brands/#{taxon}")]
  end

  @bird_mappings = {
    'canary' => 'canary',
    'wildbird' => 'wild-bird',
    'finch' => 'finch',
    'parakeet' => 'parakeet',
    'cockatiel' => 'cockatiel',
    'lovebird' => 'lovebird',
    'small_parrot' => nil,
    'eclectus' => 'eclectus',
    'hookbill' => 'hookbill',
    'conure' => 'conure',
    'macaw' => 'macaw',
    'parrot' => 'parrot',
    'parrotlet' => 'parrotlet',
    'dove' => 'wild-bird',
    'quail' => 'wild-bird',
    'guinea_pig' => 'small-animals',
    'hamster' => 'small-animals',
    'rodent' => 'small-animals',
    'small_hookbill' => nil,
    'large_parrot' => nil,
    'rabbit' => 'small-animals',
    'mouse' => 'small-animals',
    'squirrel' => 'small-animals',
    'large_hookbill' => nil,
    'chicken' => 'chicken',
    'african_grey' => 'african-grey-parrot',
    'amazon_parrot' => 'amazon-parrot',
    'pigeon' => 'pigeon',
    'lorikeet' => nil
  }
  def birds_for strs
    (strs || '').downcase.split.map do |str|
      raise "Could not find bird for '#{str}'" unless @bird_mappings.key?(str)
      bird = @bird_mappings[str]
      next bird if bird.is_a?(Spree::Taxon) || bird.nil?
      @bird_mappings[str] = Spree::Taxon.friendly.find("birds/#{bird}")
    end.compact.uniq
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

  def option_value_for weight
    weight = normalize_weight(weight)
    Spree::OptionValue
      .where(option_type: @option_types[:size], name: weight)
      .create_with(presentation: weight)
      .first_or_create!
  end

  def normalize_weight weight
    number = weight[/\./] ? weight.to_f : weight.to_i
    case weight.downcase
    when /oz/    then "#{number} ounces"
    when /#|lb/  then "#{number} pounds"
    when /caps/  then "#{number} caps"
    when /pills/ then "#{number} pills"
    when /tabs/  then "#{number} tabs"
    when /ml/    then "#{number}mL"
    when /l/     then "#{number}L"
    else byebug; raise "Could not normalize weight: '#{weight}'"
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
        product.update!(
          sku: (has_variants ? '' : master[:product_code]),
          name: master[:item_name],
          description: master[:item_description],
          taxons: (brands_for(master[:category]) + birds_for(master[:usage])),
          option_types: [@option_types[:size]],
          available_on: Time.now,
          price: master[:pricing_schedule],
          shipping_category: shipping,
          product_properties: [
            product_property_for(:directions, master[:directions]),
            product_property_for(:analysis, master[:analysis]),
            product_property_for(:additives, master[:nutritional_additives]),
            product_property_for(:ingredients, master[:ingredients])
          ].compact)
        if has_variants
          product.update!(variants: variants.map do |variant|
            record = Spree::Variant.find_or_initialize_by(
              sku: variant[:product_code])
            record.update!(
              product: product,
              price: variant[:pricing_schedule],
              option_values: [option_value_for(variant[:weight])])
            record
          end)
        else
          product.master.update!(
            option_values: [option_value_for(master[:weight])])
        end
        if ENV['images']
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
