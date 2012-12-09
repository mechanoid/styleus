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
    sample_template = _styleus_representation_wrap(class: '__boxed') { render partial: "#{partial_path}_sample" }

    plain_template = _html_representation("#{partial_path}.html.erb") { render partial: "#{partial_path}" }

    helper_template = _helper_representation { render partial: "#{partial_path}_helper" } if options[:helper]

    sample_template.concat(plain_template).concat(helper_template || safe_empty)
  end

  def option_bar(component)
    content_tag 'nav', class: '__option_bar' do
      content_tag 'ul' do
        html_area = content_tag('li') { link_to t('icons.html'), component_path(component), title: t('links.titles.html'), class: 'icon', data: { toggle: "##{component.id} [data-subject=html-representation]" } }
        helper_area = content_tag('li') { link_to t('icons.helper'), component_path(component), title: t('links.titles.helper'), class: 'icon', data: { toggle: "##{component.id} [data-subject=ruby-representation]" } } if component.helper?
        presentation_area = content_tag('li') { link_to t('icons.expand_all'), component_path(component), title: t('links.titles.expand_all'), class: 'icon', data: { toggle: "##{component.id} [data-subject*=representation]" } }

        html_area.concat(helper_area || safe_empty).concat(presentation_area)
      end
    end
  end

  def component_index(headline)
    return if @components.empty?
    content_tag 'nav', class: "__component_index" do
      menu_entries = content_tag 'ul' do
        content_tag_for(:li, @components) do |component|
          link_to component.headline, anchor: component.id
        end
      end
      content_tag('h3', headline).concat menu_entries
    end

  end

  def _styleus_article_wrap(options = { }, &block)
    captured_block = capture(&block)

    content_tag('article', class: '__sg_article', id: options[:id]) do
      content  = safe_empty
      headline = options[:headline]
      content.concat(content_tag('h3', headline)) if headline
      content.concat(captured_block)
      content
    end
  end

  def _styleus_representation_wrap(options = { }, &block)
    captured_block = capture(&block)

    classes = '__sg_component'.concat(" #{options[:class].to_s}")
    content_tag('section', class: classes) do
      render layout: 'layouts/styleus_context' do
        captured_block.to_s.html_safe
      end
    end
  end


  def _html_representation(note = nil, &block)
    _coderay_highlight_wrap(note, type: :html, &block)
  end

  def _helper_representation(&block)
    _coderay_highlight_wrap(nil, type: :ruby, &block)
  end

  def _coderay_highlight_wrap(note = nil, options = { type: :html }, &block)
    captured_block = capture(&block)
    code_block     = CodeRay.scan(captured_block.to_s, options[:type])

    note_tag = note ? content_tag('p', note, class: '__code_note') : safe_empty

    highlighted_code = "#{note_tag}#{code_block.div(:css => :class, line_numbers: :table)}"
    content_tag('div', data: { subject: "#{options[:type]}-representation" }) do
      highlighted_code.html_safe
    end
  end

  def _joined_component_list
    @component_list.join.html_safe
  end

  def safe_empty
    ''.html_safe
  end
end