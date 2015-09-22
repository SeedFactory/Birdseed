Spree::Image.class_eval do 

  attachment_definitions[:attachment]
    .merge!(Rails.application.config.paperclip_defaults)
    .merge!(styles:
      { mini: '75x75>', small: '150x150>', product: '300x300>', large: '600x600>' })

end
