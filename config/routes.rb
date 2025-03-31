Rails.application.routes.draw do
  resources :restaurants, only: [ :index, :show ] do
    resources :menus, shallow: true do
      resources :menu_menu_items, only: [ :index, :show ]
    end
  end

  resources :menu_items, only: [ :index, :show ]
  resources :menu_menu_items, only: [ :index, :show ]
  post "/import", to: "imports#create"
end
