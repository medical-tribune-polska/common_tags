CommonTags::Engine.routes.draw do
  tags_resources_actions = if CommonTags.draw_routes?
    [:index, :edit, :update, :new, :create, :destroy]
  else
    []
  end

  resources :list, only: tags_resources_actions, param: :permalink do
    resources :tags, only: tags_resources_actions do
      get 'suggestions', on: :collection
    end
  end

  resources :taggings, only: [] do
    if Rails::VERSION::STRING.to_i <= 3
      put :set, on: :collection
    else
      patch :set, on: :collection
    end
  end

  namespace :api do
    resources :tags, only: :show if CommonTags.draw_routes?
  end
end
