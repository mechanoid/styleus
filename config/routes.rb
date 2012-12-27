Rails.application.routes.draw do
  resources :components, only: [:index, :show] do
    collection do
      Styleus::Component.sections.each do |section, _|
        resources section.to_s.pluralize, only: [:index, :show], controller: :components, components: section.to_s
      end
    end
  end
end
