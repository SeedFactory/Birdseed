namespace :variants do

  def ounces size
    return size.to_f / 16 if size.ends_with?('ounces')
    return size.to_f      if size.ends_with?('pounds')
    0
  end

  def process variant
    if variant.weight.zero?
      size = variant.option_values.first.presentation
      weight = ounces(size)
      puts "#{variant.sku} #{size}" if weight.zero?
      variant.update!(weight: weight)
    end
  end

  task set_weight: :environment do
    ActiveRecord::Base.transaction do
      Spree::Product.find_each do |product|
        begin
          if product.variants.any?
            product.variants.each {|v| process(v) }
          else
            process(product.master)
          end
        rescue => e
          byebug
          raise e
        end
      end
    end
  end

end
