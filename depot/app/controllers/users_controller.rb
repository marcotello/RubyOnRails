class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.order(:name)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params false)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: "User #{@user.name} was successfully created." }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    admin_user_password_validated = true
    if params[:admin_password].present?
      #admin_user = authenticate_user(session[:user_name], params[:admin_password])
      admin_user = User.authenticate(session[:user_name], params[:admin_password])
      if admin_user.nil?
          admin_user_password_validated = false
      end
    end

    respond_to do |format|
      if admin_user_password_validated
        if @user.update(user_params true)
          logger.debug "::::::::::::::::::::::::::::::::::::::: pase por aqui tambien"
          format.html { redirect_to users_url, notice: "User #{@user.name} was successfully updated." }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        @user.errors[:base] << "Your password is not correct, please verify it and try again"
        # halts request cycle and redirect the user to the edit page.
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    begin
      @user.destroy
      flash[:notice] = "User #{@user.name} deleted"
    rescue StandardError => e
      flash[:notice] = e.message
    end
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params(require_admin_password)
      if require_admin_password
        params.require(:user).permit(:name, :password, :password_confirmation, :admin_password)
      else
        params.require(:user).permit(:name, :password, :password_confirmation)
      end
    end
end
