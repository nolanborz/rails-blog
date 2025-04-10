class SessionsController < ApplicationController
  def new
    # Login form
  end

  def create
    admin = Admin.find_by(email: params[:email])
    if admin && admin.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to root_path, notice: "Logged in successfully"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to root_path, notice: "Logged out successfully"
  end
end
