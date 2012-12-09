module StyleusHelper
  def styleus(comp_list = [])
    @components = Styleus::ViewComponent.from_hashes(comp_list)

    @component_list = @components.map do |component|
      wrap_component component
    end

    component_index.concat(_joined_component_list)
  end


  def wrap_component(component)
    option_bar(component) +
            _styleus_article_wrap(headline: component.headline, anchor_id: component.id) do
              styleus_partials(component.partial_path)
            end
  end

  def styleus_partials(partial_path)
    sample_template = _styleus_representation_wrap(class: '__boxed') do
      render partial: "#{partial_path}_sample"
    end

    plain_template = _coderay_highlight_wrap("#{partial_path}.html.erb") do
      render partial: "#{partial_path}"
    end

    sample_template.concat(plain_template)
  end

  def option_bar(component)
    content_tag 'nav', class: 'option_bar' do
      content_tag 'ul' do
        content_tag('li') { link_to t('icons.html'), component_path(component), class: 'icon', data: { toggle: "##{component.id}[data-subject=html-representation]" } }
        .concat content_tag('li') { link_to t('icons.helper'), component_path(component), class: 'icon', data: { toggle: 'rails-helper' } }
        .concat content_tag('li') { link_to t('icons.expand_all'), component_path(component), class: 'icon', data: { toggle: 'rails-helper' } }
      end
    end
  end

  def component_index
    return if @components.empty?
    content_tag 'nav' do
      content_tag 'ul' do
        content_tag_for(:li, @components) do |component|
          link_to component.headline, anchor: component.id
        end
      end
    end
  end

  def _styleus_article_wrap(options = { }, &block)
    captured_block = capture(&block)

    content_tag('article', class: '__sg_article', id: options[:anchor_id]) do
      content  = ''
      headline = options[:headline]
      content.concat(content_tag('h3', headline)) if headline
      content.concat(captured_block)
      content.html_safe
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

  def _coderay_highlight_wrap(note = nil, &block)
    captured_block = capture(&block)
    code_block     = CodeRay.scan(captured_block.to_s, :html)

    note_tag = note ? content_tag('p', note, class: '__code_note') : ''

    highlighted_code = "#{note_tag}#{code_block.div(:css => :class)}"
    highlighted_code.html_safe
  end

  def _joined_component_list
    @component_list.join.html_safe
  end
end