class MenuItemsController < ApplicationController
  before_action :set_menu_item, only: %i[ show ]

  # GET /menu_items
  def index
    @menu_items = MenuItem.all
  
    render json: @menu_items
  end

  # GET /menu_items/1
  def show
    render json: @menu_item
  end

  # POST /menu_items
  # def create
  #   @menu_item = MenuItem.new(menu_item_params)

  #   if @menu_item.save
  #     render json: @menu_item, status: :created, location: @menu_item
  #   else
  #     render json: { errors: @menu.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  # PATCH/PUT /menu_items/1
  # def update
  #   if @menu_item.update(menu_item_params)
  #     render json: @menu_item
  #   else
  #     render json: { errors: @menu.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  # DELETE /menu_items/1
  # def destroy
  #   if @menu_item.destroy
  #     head :no_content
  #   else
  #     { error: "Failed to delete menu item" }, status: :unprocessable_entity
  # end

  private
    def set_menu_item
      @menu_item = MenuItem.find(params[:id])
    end

    def menu_item_params
      params.require(:menu_item).permit(:name, :description, :category, :menu_id)
    end
end
