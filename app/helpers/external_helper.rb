require 'styleus_helper'

module ExternalHelper
  def index_documentation(&block)
    content_tag('section', class: '__index_documentation', &block).html_safe
  end

  def documentation(&block)
    content_for :documentation, _styleus_documentation_wrap(&block)
  end

  def display(&block)
    content_for :representation, capture(&block)
  end

  def html(&block)
    content_for :html, _html_representation(&block)
  end

  def helper(&block)
    content_for :helper, _helper_representation(&block)
  end

  def styleus_page(&block)
    index         = styleus_index
    components    = styleus_components
    documentation = ''
    documentation = index_documentation(&block) if block_given?
    index.concat(documentation).concat(components)
  end

  def styleus_components
    _build_view_components
    @component_list = @components.map { |component| _wrap_component component }
    @component_list.join.html_safe
  end

  def styleus_index
    _build_view_components
    _component_index(components_category, @components)
  end
end