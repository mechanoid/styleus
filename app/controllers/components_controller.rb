class ComponentsController < ApplicationController
  layout 'components'

  def index
    render_for_components
  end

  def show
    render_for_components
  end

  private

  def render_for_components
    if components?
      render "components/#{components}/#{params[:action]}"
    else
      render
    end
  end

  def components
    params[:components]
  end

  def components?
    !!params[:components]
  end
end