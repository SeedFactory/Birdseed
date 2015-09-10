# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# Note: If a preference is set here it will be stored within the cache & database upon initialization.
#       Just removing an entry from this initializer will not make the preference value go away.
#       Instead you must either set a new value or remove entry, clear cache, and remove database entry.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  # Example:
  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false
end

Spree.user_class = "Spree::User"

paperclip_defaults = if Rails.env.production?
  {
    storage: :s3,
    s3_credentials: {
      bucket: 'birdseed',
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    },
    s3_protocol: 'https',
    url: ':s3_domain_url',
    path: '/:class/:id/:style.:extension'
  }
else
  {
    path: ':rails_root/public:url',
    url: '/spree/:class/:id/:style.:extension'
  }
end

paperclip_defaults.each do |key, value|
  Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
  Spree::Taxon.attachment_definitions[:icon][key.to_sym] = value
end

Spree::Taxon.attachment_definitions[:icon].merge!(
  styles: { normal: '100x167>', normal_2x: '200x333>' },
  default_style: :normal
)
