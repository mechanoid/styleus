Rails.application.routes.draw do
  resources :components, only: [:index, :show] do
    collection do
      Styleus::Component.sections.each do |section, _|
        section_route = section.to_s.pluralize
        resources section_route, only: [:index, :show], controller: :components, components: section_route
      end
    end
  end
end
