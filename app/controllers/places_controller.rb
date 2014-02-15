class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:last_city] = params[:city]
      render :index
    end
  end
  
  def show
    params[:city] = session[:last_city]
    @place = BeermappingApi.get_place(params[:id], params[:city])
    unless @place
      redirect_to :back, :notice => "Place not found"
    else
      render :show
    end
  end
end
