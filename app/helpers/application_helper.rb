module ApplicationHelper

  def app_url_helpers
    Rails.application.routes.url_helpers
  end

  def brand product
    @brands_taxonomy ||= Spree::Taxonomy.find_by(name: 'Brands')
    product.taxons.find_by(taxonomy: @brands_taxonomy).try(:name)
  end

  def option_values variant
    variant.option_values.sort_by do |ov|
      ov.option_type.position
    end.map(&:presentation).join(', ')
  end

  def price variant
    Spree::Money.new(variant.price, { currency: current_currency }).to_html
  end

  def cc_type_for card
    card.brand? ? card.brand.titleize : 'Credit Card'
  end

  def form_group form, method, label: nil, collection: nil
    classes = "form-group" << error_class(form.object.errors, method)
    content_tag(:div, class: classes) do
      form.label(method, label || method.to_s.titleize) <<
      form_group_field(form, method, collection) <<
      error_hint(form.object.errors, method)
    end
  end

  def error_class errors, method
    errors.include?(method) ? ' has-error' : ''
  end

  def error_hint errors, method
    method = method.to_s.sub(/_id$/, '').to_sym
    if errors.include?(method)
      content_tag :span, class: 'help-block' do
        errors.get(method).to_sentence
      end
    else '' end
  end

  def parse_property_value product_property
    product_property.value.split("\n").map! do |line|
      index = line.index(/[\d\.,]+[^\d\.,]+$/)
      [line[0...index], line[index..-1]]
    end
  end

  def format_property_value? product_property
    product_property.property.name.in? %w(additives analysis)
  end

  private

  def form_group_field form, method, collection
    if collection
      form.collection_select method, *collection
    else
      case method
      when :email
        form.email_field(method)
      when :password
        form.password_field(method)
      when :phone, :zipcode
        form.telephone_field(method)
      else
        form.text_field(method)
      end
    end
  end

end
