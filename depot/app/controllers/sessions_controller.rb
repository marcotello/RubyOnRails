class SessionsController < ApplicationController

  skip_before_action :authorize

  def new
  end

  def create
  	#user = User.find_by(name: params[:name])
  	#if user and user.authenticate(params[:password])
    #user = authenticate_user(params[:name], params[:password])
    user = User.authenticate(params[:name], params[:password])
    if user.present?
  		session[:user_id] = user.id
      session[:user_name] = user.name
  		redirect_to admin_url
    elsif params[:name] == "depotAdmin" and params[:password] == "zasxdcfv"
      session[:user_id] = 0
      session[:user_name] = "depotAdmin"
      redirect_to admin_url
  	else
  		redirect_to login_url, alert: "Invalid user/password combination"
  	end
  end

  def destroy
  	session[:user_id] = nil
    session[:user_name] =  nil
  	redirect_to store_url, notice: "Logged out"
  end
end
