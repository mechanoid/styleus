module StyleusRepresenterHelper
  def _option_bar(component)
    _render_styleus('option_bar', locals: { component: component })
  end

  def _component_index(headline, components)
    _render_styleus('component_index', locals: { headline: headline, components: components })
  end

  def _article(component, &block)
    _render_styleus('article', locals: { headline: component.headline, id: component.id, component: component }, &block)
  end

  def _component(classes, &block)
    _render_styleus('component', locals: { classes: classes }, &block)
  end

  def _code_note(note)
    note ? _render_styleus('code_note', object: note) : _safe_empty
  end

  def _code(code, type)
    _render_styleus 'code', object: code, locals: { type: type }
  end

  def _render_styleus(styleus_partial, options = { }, &block)
    render_type    = block_given? ? 'layout' : 'partial'
    partial_path   = "styleus/#{styleus_partial}"
    render_options = { :"#{render_type}" => partial_path }.merge options
    render render_options, &block
  end

  def _safe_empty
    ''.html_safe
  end
end