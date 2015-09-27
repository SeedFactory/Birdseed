module ApplicationHelper

  def products_cache_key
    [ @products.maximum(:updated_at) || Time.now,
      params[:page],
      params[:bird],
      params[:brand],
      params[:query],
      @products.count
    ].compact
  end

  def taxons_cache_key
    [ (@birds || @brands).maximum(:updated_at) || Time.now,
      @bird,
      @brand,
    ].compact
  end

  def high_dpi_images
    @high_dpi_images ||= {}
  end

  def low_dpi_images
    @low_dpi_images ||= {}
  end

  def reset_responsive_images!
    @low_dpi_images = {}
    @high_dpi_images = {}
  end

  def responsive_image_tag attachment, low_dpi_style, high_dpi_style, options = {}
    path = URI(attachment.url(low_dpi_style)).path
    id = path.split(/[\/\.]/)[2..-2].join('-').dasherize
    options[:class] = [options[:class], "responsive-image-#{id}"].compact
    high_dpi_images[id] = attachment.url high_dpi_style
    low_dpi_images[id] = attachment.url low_dpi_style
    content_tag :figure, '', options
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
      index ? [line[0...index], line[index..-1]] : [line]
    end
  end

  def format_property_value? product_property
    product_property.property.name.in? %w(additives analysis)
  end

  def pagination_for collection
    content_tag :nav, class: 'shop-pagination' do
      content_tag :ul, class: 'pagination' do
        content_tag(:li, class: ('disabled' if collection.first_page?)) do
          link_to '&laquo;'.html_safe, url_for_page(collection.prev_page)
        end <<
        (1..collection.num_pages).map do |i|
          content_tag :li, class: ('active' if collection.current_page == i) do
            link_to i, url_for_page(i)
          end
        end.join.html_safe <<
        content_tag(:li, class: ('disabled' if collection.last_page?)) do
          link_to '&raquo;'.html_safe, url_for_page(collection.next_page)
        end
      end
    end if collection.num_pages > 1
  end

  def url_for_page page
    path = request.fullpath.sub(/[\?&]?page=\d+/, '')
    "#{path}#{path['?'] ? '&' : '?'}page=#{page}"
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
