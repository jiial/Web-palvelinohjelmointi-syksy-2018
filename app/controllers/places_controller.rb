class PlacesController < ApplicationController
  before_action :set_place, only: [:show]

  def index
  end

  def show
  end

  def search
    @weather = ApixuApi.weather_in(params[:city])
    @places = BeermappingApi.places_in(params[:city])
    session[:last_search] = params[:city]
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end

  def set_place
    @places = Rails.cache.read(session[:last_search])
    @places.each do |place|
      if place.id == params[:id]
        @place = place
      end
    end
  end
end
