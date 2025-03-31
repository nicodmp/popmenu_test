class MenuMenuItemsController < ApplicationController
  before_action :set_menu_menu_item, only: [:show]

  # GET /menus/:menu_id/menu_menu_items
  def index
    if params[:menu_id]
      @menu = Menu.find(params[:menu_id])
      @associations = @menu.menu_menu_items.includes(:menu_item)
    else
      @associations = MenuMenuItem.all.includes(:menu_item)
    end
    render json: @associations.to_json(include: :menu_item)
  end

  # GET /menus/:menu_id/menu_menu_items/1
  def show
    render json: @menu_menu_item
  end

  private

  def set_menu_menu_item
    @menu_menu_item = MenuMenuItem.find(params[:id])
  end

  def menu_menu_item_params
    params.require(:menu_menu_item).permit(:menu_item_id, :price)
  end
end
