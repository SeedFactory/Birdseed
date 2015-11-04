object @image
attributes *image_attributes
attributes :viewable_type, :viewable_id
styles = Spree::Image.attachment_definitions[:attachment][:styles].keys
(styles + [:original]).each do |style|
  node("#{style}_url") { |i| i.attachment.url(style) }
end
