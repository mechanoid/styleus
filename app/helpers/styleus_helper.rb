require 'styleus_representer_helper'

module StyleusHelper
  def styleus(comp_list = [])
    @components = Styleus::ViewComponent.from_hashes(comp_list)

    @component_list = @components.map do |component|
      wrap_component component
    end

    component_index(components_category).concat(_joined_component_list)
  end

  def wrap_component(component)
    article = _styleus_article_wrap(headline: component.headline, id: component.id) do
      styleus_partials(component.partial_path, helper: component.helper?)
    end
    option_bar(component).concat article
  end

  def styleus_partials(partial_path, options = { })
    sample_template = _styleus_component_wrap(class: '__boxed') { render partial: "#{partial_path}_sample" }

    plain_template = _html_representation("#{partial_path}.html.erb") { render partial: "#{partial_path}" }

    helper_template = _helper_representation { render partial: "#{partial_path}_helper" } if options[:helper]

    sample_template.concat(plain_template).concat(helper_template || _safe_empty)
  end

  def option_bar(component)
    _option_bar(component)
  end

  def component_index(headline)
    _component_index(headline, @components)
  end

  def _styleus_article_wrap(options = { }, &block)
    captured_block = capture(&block)
    _article(options) { captured_block }
  end

  def _styleus_component_wrap(options = { }, &block)
    captured_block = capture(&block)
    classes        = %W{__sg_component #{options[:class]}}.join(' ')
    _component(classes) { captured_block }
  end


  def _html_representation(note = nil, &block)
    _coderay_highlight_wrap(note, &block)
  end

  def _helper_representation(&block)
    _coderay_highlight_wrap('Rails Helper', type: :ruby, &block)
  end

  def _coderay_highlight_wrap(note = nil, options = { }, &block)
    captured_block = capture(&block)
    type           = options[:type] || :html

    highlighted_code = _highlight(captured_block.to_s, type)
    code_with_note   = _code_note(note).concat highlighted_code

    _code(code_with_note, type)
  end

  def _joined_component_list
    @component_list.join.html_safe
  end

  def _highlight(code, type)
    CodeRay.scan(code, type).div(:css => :class, line_numbers: :table).html_safe
  end
end