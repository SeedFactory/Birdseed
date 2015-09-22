Spree::Taxon.class_eval do

  attachment_definitions[:icon]
    .merge!(Rails.application.config.paperclip_defaults)
    .merge!(styles: { normal: '100x167>', normal_2x: '200x333>' },
      default_style: :normal)
  
  def needs_border? style = nil
    image = Magick::Image.read(icon.path(style)).first
    corners = [0, image.columns - 1].product([0, image.rows - 1]).map do |x, y|
      image.get_pixels(x, y, 1, 1).first
    end
    corners.select do |pixel|
      ((pixel.red + pixel.green + pixel.blue) >> 8) / 3.0 > 250
    end.length > 2
  end

end
