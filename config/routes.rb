Rails.application.routes.draw do
  resources :components, only: [:index, :show] do
    collection do
      Styleus::COMPONENT_SPACES.each do |c|
        resources c, only: [:index, :show], controller: :components, components: c.to_s
      end
    end
  end
end
