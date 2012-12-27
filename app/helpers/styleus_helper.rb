require 'styleus_representer_helper'

module StyleusHelper
  def _section
    params[:components]
  end

  def _application_context(&block)
    captured_block = capture(&block)

    layout_name = 'styleus_context'
    file_name   = "_#{layout_name}.html.erb"

    if _layout_exists?(file_name)
      render(layout: File.join('layouts', layout_name)) { captured_block }
    else
      captured_block
    end
  end

  def _component_context(file_path, &block)
    captured_block = capture(&block)

    view_path = _folder_path(file_path)

    partial_name = 'component_context'
    partial_path = File.join view_path, 'component_context'
    file_path    = File.join view_path, "_#{partial_name}.html.erb"

    if _partial_exists?(file_path)
      render(layout: partial_path) { captured_block }
    else
      captured_block
    end
  end

  def _folder_path(path)
    path = path.split(File::SEPARATOR)
    path.pop
    path.join(File::SEPARATOR)
  end

  def _partial_exists?(view_path)
    file_path = Rails.root.join('app', 'views', view_path)
    File.exists? file_path
  end

  def _layout_exists?(file_name)
    file_path = Rails.root.join('app', 'views', 'layouts', file_name)
    File.exists? file_path
  end

  # this heart of gold function renders the app component partials
  # and enables the configured content_for blocks for the target
  # partial called styleus_partials.
  def _styleus_partials(component, options = { })
    _clear_content_for_registrations(:documentation, :representation, :html, :helper)
    # execute application partial without responding it directly,
    # so only the given content_for methods will help.
    render partial: "#{component.partial_path}", locals: { component: component }

    # returning concatenating responder partial, which consists of content_for blocks only.
    result = render(layout: 'styleus/styleus_partials', locals: { component: component }) { }
    flush_output_buffer
    _clear_content_for_registrations(:documentation, :representation, :html, :helper)
    result
  end

  # clean up content_for blocks, so same content_for names can be used several times
  def _clear_content_for_registrations(*content_names)
    # clear content_for calls for this name
    content_names.each { |content_name| @view_flow.set(content_name, '') }
  end


  # converts the list of component hashes configured in the
  # app to a list of ViewComponent instances.
  def _build_view_components
    @components ||= Styleus::ViewComponent.from_names(_section, _section_class.components)
  end

  def _section_class
    _section.camelcase.singularize.constantize
  end

  # wraps a component in an article and combines it with
  # a depending optionbar, that enables the user to show
  # and hide the different partials.
  def _wrap_component(component)
    _styleus_article_wrap(component) do
      _styleus_partials(component)
    end
  end

  def _option_bar(component)
    _option_bar(component)
  end

  # renders an article attribute wrap for a component
  def _styleus_article_wrap(component, &block)
    captured_block = capture(&block)
    _article(component) { captured_block }
  end

  def _styleus_component_wrap(options = { }, &block)
    captured_block = capture(&block)
    classes        = %W{__sg_component #{options[:class]}}.join(' ')
    _component(classes, options[:partial_path]) { captured_block }
  end

  # TODO: what does this method do?
  def _styleus_documentation_wrap(options = { }, &block)
    captured_block = capture(&block)
  end

  def _html_representation(&block)
    _coderay_highlight_wrap('HTML Snippet', &block)
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

  def _highlight(code, type)
    CodeRay.scan(code, type).div(:css => :class, line_numbers: :table).html_safe
  end
end