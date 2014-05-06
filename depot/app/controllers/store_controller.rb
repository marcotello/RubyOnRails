class StoreController < ApplicationController
  include CurrentCart

  skip_before_action :authorize

  before_action :count_store_views, only: [:index]
  before_action :set_cart

  def index
    if params[:set_locale]
      redirect_to store_url(locale: params[:set_locale])
    else
      @products = Product.order(:title)
    end
    @views = session[:store_views]
  end

  def count_store_views
  	if session[:store_views].nil?
  		session[:store_views] = 1
  	else
  		session[:store_views] += 1
  	end
  end
end
