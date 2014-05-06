class OrdersController < ApplicationController
  include CurrentCart

  skip_before_action :authorize, only: [:new, :create]

  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_order

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    if @cart.line_items.empty?
      redirect_to store_url, notice: "Your cart is empty"
      return
    end

    @order = Order.new
    #@payment_types = PaymentType.all
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    #raise an error with the params
    #raise order_params.inspect
    #  logger.error "*******************     Attempt to save a balnk payment method #{params[:payment_type_id].present?}"
    @order = Order.new(order_params false)
    @order.add_new_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save

        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil

        #Sending the Confirmation Email
        OrderNotifier.received(@order).deliver

        format.html { redirect_to store_url, notice: I18n.t('.thanks') }
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)

        #Sending the Shipment Confirmation Email
        OrderNotifier.shipped(@order).deliver

        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    #Rescue from error 
    def invalid_order
      error = "Attempt to access invalid order with the order_id = #{params[:id]}"
      logger.error error
      #ErrorNotifier.raised(error, controller.controller_name, controller.action_name).deliver
      ErrorNotifier.raised(error, params[:controller], params[:action]).deliver
      redirect_to store_url, notice: 'Invalid Order'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params(shipping_date_permited=true)
      if shipping_date_permited
        params.require(:order).permit(:name, :address, :email, :payment_type_id, :shipping_date)
      else
        params.require(:order).permit(:name, :address, :email, :payment_type_id)
      end
    end
  end
