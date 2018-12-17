class BuyersController < ApplicationController
  before_action :set_buyer, only: [:show, :edit, :update, :destroy]
  before_action :require_logged_out, only: [:new]
  require_user, except: [:new]
  before_action :require_same_user, only: [:edit, :update, :delete, :show]



 def require_same_user
   if buyer_logged_in?
   @curuser = Buyer.find(session[:buyer_id])
     if @curuser != Buyer.find(params[:id]) && !admin_logged_in?
       redirect_to buyer_url(session[:buyer_id])
     end
   elsif seller_logged_in?
     redirect_to buyer_url(session[:seller_id])
 end
 end

  # GET /buyers
  # GET /buyers.json
  def index
    @buyers = Buyer.all
  end

  # GET /buyers/1
  # GET /buyers/1.json
  def show
    @sale = Sale.all
  end

  # GET /buyers/new
  def new
    @buyer = Buyer.new
  end

  # GET /buyers/1/edit
  def edit
  end

  def buy
    @sale = Sale.find(params[:id])
    @sale.buyer_id = session[:buyer_id]
    redirect_to buyer_path(session[:buyer_id])
  end

  # POST /buyers
  # POST /buyers.json
  def create
    @buyer = Buyer.new(buyer_params)

    respond_to do |format|
      if @buyer.save
        session[:buyer_id] = params[:id]
        format.html { redirect_to login_path, notice: 'Welcome, new buyer! Start shopping!' }
        format.json { render :show, status: :created, location: @buyer }
      else
        format.html { render :new }
        format.json { render json: @buyer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buyers/1
  # PATCH/PUT /buyers/1.json
  def update
    respond_to do |format|
      if buyer_logged_in?
        if @buyer.update(buyer_params)
          format.html { redirect_to @buyer, notice: 'Buyer was successfully updated.' }
          format.json { render :show, status: :ok, location: @buyer }
        else
          format.html { render :edit }
          format.json { render json: @buyer.errors, status: :unprocessable_entity }
        end
      elsif admin_logged_in?
        if @buyer.update(buyer_params)
          format.html { redirect_to dashboard_path(session[:admin]), notice: 'Buyer was successfully updated.' }
          format.json { render :show, status: :ok, location: @buyer }
        else
          format.html { render :edit }
          format.json { render json: @buyer.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /buyers/1
  # DELETE /buyers/1.json
  def destroy
    @buyer.destroy
    respond_to do |format|
      if admin_logged_in?
      format.html { redirect_to dashboard_path, notice: 'Buyer was successfully deleted.' }
      elsif buyer_logged_in?
        format.html { redirect_to logout_path, notice: 'Account was successfully deleted.' }
      end
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_buyer
      @buyer = Buyer.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def buyer_params
      params.require(:buyer).permit(:first_name,:last_name, :email, :password,:birthday)
    end

    def sale_params
      params.require(:sale).permit(:seller_id, :product_id, :price, :buyer_id)
    end
end
