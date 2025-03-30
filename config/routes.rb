Rails.application.routes.draw do
  resources :menus, only: [ :index, :show ] do
    resources :menu_items, only: [ :index, :show ]
  end

  resources :menu_items, except: [ :index, :show ]
end
