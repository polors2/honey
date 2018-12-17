class PageController < ApplicationController
  before_action :require_logged_out, except: [:admin]
  before_action :require_admin, only: [:admin]



  def index
    @sale = Sale.all
  end

  def products
  @products ||= find_products
end
end
