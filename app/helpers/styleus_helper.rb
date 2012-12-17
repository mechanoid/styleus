require 'styleus_representer_helper'

module StyleusHelper

  # this heart of gold function renders the app component partials
  # and enables the configured content_for blocks for the target
  # partial called styleus_partials.
  def _styleus_partials(component, options = { })
    # execute application partial without responding it directly,
    # so only the given content_for methods will help.
    render partial: "#{component.partial_path}"

    # returning concatenating responder partial, which consists of content_for blocks only.
    render(layout: 'styleus/styleus_partials', locals: { component: component }) { }
  end

  # To use the render layout: '...' method multiple times
  # for the several components, including the same content_for
  # blocks each time, we have to clean up them before registering
  # the next blocks.
  #
  # So this function wraps the content_for function with
  # a prepended clearing for the specific content_for attribute,
  # so that earlier defined content_for areas are not
  # rendered again.
  def _cleared_content_for(content_name, content)
    # clear content_for calls for this name
    @view_flow.set(content_name, '')

    # set new content_for for this name
    content_for content_name, content
  end


  # converts the list of component hashes configured in the
  # app to a list of ViewComponent instances.
  def _build_view_components(comp_list)
    @components ||= Styleus::ViewComponent.from_hashes(comp_list)
  end

  # wraps a component in an article and combines it with
  # a depending optionbar, that enables the user to show
  # and hide the different partials.
  def _wrap_component(component)
    _styleus_article_wrap(component) do
      _styleus_partials(component, helper: component.helper?)
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
    _component(classes) { captured_block }
  end

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