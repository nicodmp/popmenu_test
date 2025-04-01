Rails.application.routes.draw do
  resources :restaurants, only: [ :index, :show ] do
    resources :menus, shallow: true
  end

  resources :menu_items, only: [ :index, :show ]
  post "/import", to: "imports#create"
end
