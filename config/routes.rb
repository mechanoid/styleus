Rails.application.routes.draw do
  COMPONENTS = [:containers, :forms, :service_forms]

  resources :components, only: [:index] do
    collection do
      COMPONENTS.each do |c|
        resources c, only: [:index, :show], controller: :components, components: c.to_s
      end
    end
  end
end
