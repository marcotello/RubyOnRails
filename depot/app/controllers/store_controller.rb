class StoreController < ApplicationController
  include CurrentCart

  before_action :count_store_views, only: [:index]
  before_action :set_cart

  def index
  	@products = Product.order(:title)
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
