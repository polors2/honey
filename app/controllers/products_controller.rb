class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :require_user
  before_action :seller_or_admin, only: [:new, :index, :show]
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


  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    @cat = Category.all
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if seller_logged_in?
        if @product.save
          format.html { redirect_to seller_path(session[:seller_id]), notice: 'Product was successfully created.' }
          format.json { render :show, status: :created, location: @product }
        else
          format.html { render :new }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      elsif admin_logged_in?
        if @product.save
          format.html { redirect_to products_path, notice: 'Product was successfully created.' }
          format.json { render :show, status: :created, location: @product }
        else
          format.html { render :new }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
    if seller_logged_in?
        if @product.update(product_params)
          format.html { redirect_to seller_path(session[:seller_id]), notice: 'Product was successfully updated.' }
          format.json { render :show, status: :ok, location: @product }
        else
          format.html { render :edit }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
    elsif admin_logged_in?
      if @product.update(product_params)
        format.html { redirect_to products_path, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name,:description,:category_id)
    end
end
