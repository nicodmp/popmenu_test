class MenusController < ApplicationController
  before_action :set_menu, only: %i[ show ]

  # GET /restaurants/:restaurant_id/menus or GET /menus
  def index
    if params[:restaurant_id]
      @restaurant = Restaurant.find(params[:restaurant_id])
      @menus = @restaurant.menus
    else
      @menus = Menu.all

    render json: @menus, include: :menu_items
  end

  # GET /menus/1
  def show
    render json: @menu, include: :menu_items
  end

  # POST /menus
  # def create
  #   @menu = Menu.new(menu_params)

  #   if @menu.save
  #     render json: @menu, status: :created, location: @menu
  #   else
  #     render json: { errors: @menu.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  # PATCH/PUT /menus/1
  # def update
  #   if @menu.update(menu_params)
  #     render json: @menu
  #   else
  #     render json: { errors: @menu.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  # DELETE /menus/1
  # def destroy
  #   if @menu.destroy
  #     head :no_content
  #   else
  #     { error: "Failed to delete menu" }, status: :unprocessable_entity
  #   end
  # end

  private

  def set_menu
    @menu = Menu.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(:name, :description, :open_time, :close_time)
  end
end
