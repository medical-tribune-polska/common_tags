CommonTags::Engine.routes.draw do
  resources :tags if CommonTags.draw_routes?

  get 'tags/suggestions', as: 'suggestions_tags'

  resources :taggings, only: [] do
    patch :set, on: :collection
  end

  namespace :api do
    resources :tags, only: :show if CommonTags.draw_routes?
  end
end
