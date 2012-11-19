module StyleusHelper
  def styleus(components = [])
    menu_entries      = []
    component_listing = components.map do |options|
      styleus_component(options[:headline], options[:partial_path], menu_entries)
    end

    styleus_list(menu_entries).concat(component_listing.join.html_safe)
  end

  def styleus_component(headline, partial_path, menu = nil)
    # create a "unique" id for anchor tags
    #TODO make it really unique ^^
    component_id = "#{headline}#{rand(999)}".underscore

    # add component to linked list menu
    menu.push({ id: component_id, headline: headline }) if menu

    _styleus_article_wrap(headline: headline, anchor_id: component_id) do
      styleus_partials(partial_path)
    end
  end

  def styleus_partials(partial_path)
    sample_template = _styleus_representation_wrap(class: '__boxed') do
        render partial: "#{partial_path}_sample"
      end

      plain_template = _coderay_highlight_wrap("#{partial_path}.html.erb") do
        render partial: "#{partial_path}_plain"
      end

      sample_template.concat(plain_template)
  end

  def styleus_list(menu_entries)
    content_tag 'nav' do
      content_tag 'ul' do
        link_list = menu_entries.map do |entry|
          content_tag 'li' do
            link_to entry[:headline], anchor: entry[:id]
          end
        end
        link_list.join.html_safe
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
    classes        = '__sg_component'.concat(" #{options[:class].to_s}")
    content_tag('section', class: classes) do
      captured_block.to_s.html_safe
    end
  end

  def _coderay_highlight_wrap(note = nil, &block)
    captured_block = capture(&block)
    code_block     = CodeRay.scan(captured_block.to_s, :html)
    note_tag       = note ? content_tag('p', note, class: '__code_note') : ''

    highlighted_code = "#{note_tag}#{code_block.div(:css => :class)}"
    highlighted_code.html_safe
  end
end