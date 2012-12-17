require 'styleus_helper'

module ExternalHelper
  def index_documentation(&block)
    content_tag('section', class: '__index_documentation', &block).html_safe
  end

  def documentation(&block)
    _cleared_content_for :documentation, _styleus_documentation_wrap(&block)
  end

  def display(&block)
    _cleared_content_for :representation, _styleus_component_wrap(&block)
  end

  def html(&block)
    _cleared_content_for :html, _html_representation(&block)
  end

  def helper(&block)
    _cleared_content_for :helper, _helper_representation(&block)
  end

  def styleus_page(comp_list = [])
    return if comp_list.empty?
    index      = styleus_index(comp_list)
    components = styleus_components(comp_list)
    index.concat(components)
  end

  def styleus_components(comp_list)
    _build_view_components(comp_list)

    @component_list = @components.map { |component| _wrap_component component }

    @component_list.join.html_safe
  end

  def styleus_index(comp_list)
    _build_view_components(comp_list)
    _component_index(components_category, @components)
  end
end