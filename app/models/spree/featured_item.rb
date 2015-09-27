class Spree::FeaturedItem < ActiveRecord::Base

  # So that the 'type' column does not trigger single table inheritance.
  self.inheritance_column = :_type_disabled

  has_attached_file :image, styles:
    { normal: ['300x300>', :png], normal_2x: ['600x600>', :png] }

  validates_presence_of :title, :body, :type, :url, :position
  validates_inclusion_of :active, in: [true, false]
  validates_length_of :title, :body, :type, :url, maximum: 255
  validates_attachment :image, presence: true,
    content_type: { content_type: ['image/png'], message: 'must be a PNG' }

  after_initialize :set_defaults

  def self.active
    where(active: true)
  end

  def self.ordered
    order(:position)
  end

  private

  def set_defaults
    if new_record?
      self.active = true
      self.position = 0
    end
  end

end
