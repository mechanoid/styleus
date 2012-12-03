module StyleusHelper
  def styleus(comp_list = [])
    component_list = ComponentList.from_hashes(comp_list)

    component_listing = component_list.components.map do |component|
      wrap_component component
    end

    #component_menu(component_list).concat(
    component_listing.join.html_safe
    #)
  end

  def wrap_component(component)
    # add component to linked list menu
    #menu.push({ id: component.id, headline: component.headline }) if menu
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

  def component_menu(component_list)
    content_tag 'nav' do
      content_tag 'ul' do
        content_tag_for(:li, component_list.components) do |component|
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
    captured_block   = capture(&block)
    code_block       = CodeRay.scan(captured_block.to_s, :html)

    note_tag       = note ? content_tag('p', note, class: '__code_note') : ''

    highlighted_code = "#{note_tag}#{code_block.div(:css => :class)}"
    highlighted_code.html_safe
  end
end