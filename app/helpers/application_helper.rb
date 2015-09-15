module ApplicationHelper

  def app_url_helpers
    Rails.application.routes.url_helpers
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
    if errors.include?(method)
      content_tag :span, class: 'help-block' do
        errors.get(method).to_sentence
      end
    else '' end
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
      else
        form.text_field(method)
      end
    end
  end

end
