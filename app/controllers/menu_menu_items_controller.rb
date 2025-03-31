class MenuMenuItemsController < ApplicationController
  # GET /menus/:menu_id/menu_menu_items
  def index
    @menu = Menu.find(params[:menu_id])
    @associations = @menu.menu_menu_items.includes(:menu_item)
    render json: @associations.to_json(include: :menu_item)
  end

  # GET /menu_menu_items/1
  def show
    render json: @menu_menu_item
  end

  private
    # Only allow a list of trusted parameters through.
    def menu_menu_item_params
      params.require(:menu_menu_item).permit(:menu_item_id)
    end
end
