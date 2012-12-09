class ComponentsController < ApplicationController
  layout 'components'

  helper_method :components_category, :components_category?

  def index
    render_for_components
  end

  def show
    render_for_components
  end

  private

  def render_for_components
    if components_category?
      render "components/#{components_category}/#{params[:action]}"
    else
      render
    end
  end

  def components_category
    params[:components]
  end

  def components_category?
    !!params[:components]
  end
end