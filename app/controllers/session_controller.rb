class SessionController < ApplicationController
  def new
    render 'new'
  end
  def destroy
    session[:buyer_id] = nil
    session[:seller_id] = nil
    session[:admin_id] = nil
    # flash[:notice] = "Logged out"
    redirect_to root_path
  end
  def create
    user = Buyer.find_by(email: params[:session][:email])
    if user != nil
      if user.authenticate(params[:session][:password])
        session[:buyer_id] = user.id
        redirect_to buyer_path(user.id)
      else
        flash.now[:danger] = "wrong password"
        render 'new'
      end
    end
    user = Seller.find_by(email: params[:session][:email])
    if user != nil
      if user && user.authenticate(params[:session][:password])
        session[:seller_id] = user.id
        redirect_to seller_path(user.id)
      else
        flash.now[:danger] = "wrong password"
        render 'new'
      end
    end
    user = Admin.find_by(email: params[:session][:email])
    if user != nil
      if user && user.authenticate(params[:session][:password])
        session[:admin_id] = user.id
        redirect_to dashboard_path(user.id)
      else
        flash.now[:danger] = "wrong password"
        render 'new'
      end
    end
  end
end
