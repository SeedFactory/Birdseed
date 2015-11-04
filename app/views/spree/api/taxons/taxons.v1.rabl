node do |t|
  child t.children => :taxons do
    attributes *taxon_attributes
    node('icon_url') { |t| t.icon.url(:original) }
    extends "spree/api/taxons/taxons"
  end
end
