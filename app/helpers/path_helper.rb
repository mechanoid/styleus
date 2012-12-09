module PathHelper
  def component_path(component)
    components = params[:components]
    return super(component) unless components

    send("#{components.singularize}_path".to_sym, component.id) if components
  end
end