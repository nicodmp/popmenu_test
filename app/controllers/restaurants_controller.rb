class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: %i[ show ]

  # GET /restaurants
  def index
    @restaurants = Restaurant.all

    render json: @restaurants, include: { menus: { include: :menu_items } }
  end

  # GET /restaurants/1
  def show
    render json: @restaurant, include: { menus: { include: :menu_items } }
  end

  # POST /restaurants
  # def create
  #   @restaurant = Restaurant.new(restaurant_params)

  #   if @restaurant.save
  #     render json: @restaurant, status: :created, location: @restaurant
  #   else
  #     render json: { errors: @restaurant.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  # PATCH/PUT /restaurants/1
  # def update
  #   if @restaurant.update(restaurant_params)
  #     render json: @restaurant
  #   else
  #     render json: { errors: @restaurant.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  # DELETE /restaurants/1
  # def destroy
  #   if @restaurant.destroy
  #     head :no_content
  #   else
  #     { error: "Failed to delete restaurant" }, status: :unprocessable_entity
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def restaurant_params
      params.require(:menu).permit(:name, :location, :open_time, :close_time, categories: [])
    end
end
