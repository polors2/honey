class SellersController < ApplicationController
  before_action :set_seller, only: [:show, :edit, :update, :destroy]
  before_action :require_logged_out, only: [:new]
  before_action :require_user, except: [:new]
  before_action :require_same_user, only: [:edit, :update, :delete, :show]



  def require_same_user
    if seller_logged_in?
    @curuser = Seller.find(session[:seller_id])
      if @curuser != Seller.find(params[:id]) && !admin_logged_in?
        redirect_to seller_url(session[:seller_id])
      end
    elsif buyer_logged_in?
      redirect_to buyer_url(session[:buyer_id])
  end
  end

  # GET /sellers
  # GET /sellers.json
  def index
    @sellers = Seller.all
  end

  # GET /sellers/1
  # GET /sellers/1.json
  def show
    @sale = Sale.all
  end

  # GET /sellers/new
  def new
    @seller = Seller.new
  end

  # GET /sellers/1/edit
  def edit
  end

  # POST /sellers
  # POST /sellers.json
  def create
    @seller = Seller.new(seller_params)

    respond_to do |format|
      if @seller.save
        format.html { redirect_to login_path, notice: 'Seller was successfully created.' }
        format.json { render :show, status: :created, location: @seller }
      else
        format.html { render :new }
        format.json { render json: @seller.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sellers/1
  # PATCH/PUT /sellers/1.json
  def update
    respond_to do |format|
      if seller_logged_in?
        if @seller.update(seller_params)
          format.html { redirect_to @seller, notice: 'Welcome, new seller! Start earning!' }
          format.json { render :show, status: :ok, location: @seller }
        else
          format.html { render :edit }
          format.json { render json: @seller.errors, status: :unprocessable_entity }
        end
      elsif admin_logged_in?
        if @seller.update(seller_params)
          format.html { redirect_to dashboard_path(session[:admin_id]), notice: 'Welcome, new seller! Start earning!' }
          format.json { render :show, status: :ok, location: @seller }
        else
          format.html { render :edit }
          format.json { render json: @seller.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /sellers/1
  # DELETE /sellers/1.json
  def destroy
    @seller.destroy
    respond_to do |format|
      if admin_logged_in?
      format.html { redirect_to dashboard_path, notice: 'Seller was successfully destroyed.' }
      elsif seller_logged_in?
        format.html { redirect_to logout_path, notice: 'Seller was successfully destroyed.' }
      end
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seller
      @seller = Seller.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def seller_params
      params.require(:seller).permit(:first_name,:last_name, :email, :password,:birthday)
    end
end
