require 'csv'

task import: :environment do

  BRAND_MAPPINGS = {
    'avian science super diet ' => 'avian-science',
    'single seed' => nil,
    'wild bird' => 'volkman-wild-bird'
  }
  def brands_for str
    raise "Could not find brand for '#{str}'" unless BRAND_MAPPINGS.key?(str)
    taxon = BRAND_MAPPINGS[str]
    taxon ? [Spree::Taxon.friendly.find("brands/#{taxon}")] : []
  end

  ActiveRecord::Base.transaction do
    size_option = Spree::OptionType.where(name: 'size').create_with(presentation: 'Size').first_or_create
    rows = CSV.table(File.expand_path(ENV['csv'])).send(:table)
    rows.select!{|row| row[:birdseedcom] == 'x' }
    products = rows.group_by{|row| row[:product_grouping] }
    products.each_value do |master, *variants|
      product = Spree::Product.create(
        sku: master[:product_code],
        name: master[:item_name],
        description: master[:item_description],
        taxons: brands_for(master[:category]),
        option_types: [size_option],
        available_on: Time.now,
        price: 1)
      variants.each do |variant|
        option = Spree::OptionValue.where(
          option_type: size_option,
          name: variant[:weight]
        ).create_with(
          presentation: variant[:weight]
        ).first_or_create
        Spree::Variant.create(
          product: product,
          option_values: [option])
      end
    end
  end
end
