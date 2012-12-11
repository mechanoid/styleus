require 'styleus_helper'

module ExternalHelper
  def display(&block)
    @view_flow.set(:representation, '')
    content_for :representation, _styleus_component_wrap(&block)
  end

  def html(&block)
    @view_flow.set(:html, '')
    content_for :html, _html_representation(&block)
  end

  def helper(&block)
    @view_flow.set(:helper, '')
    content_for :helper, _helper_representation(&block)
  end

  def styleus_page(comp_list = [])
    return if comp_list.empty?
    index      = styleus_index(comp_list)
    components = styleus_components(comp_list)
    index.concat(components)
  end

  def styleus_components(comp_list)
    build_view_components(comp_list)

    @component_list = @components.map { |component| wrap_component component }

    @component_list.join.html_safe
  end

  def styleus_index(comp_list)
    build_view_components(comp_list)
    _component_index(components_category, @components)
  end
end