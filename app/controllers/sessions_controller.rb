class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(*user_params.values)
    if @user
      login_user!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = ["Username or password was wrong."]
      @user = User.new(user_params)
      render :new
    end
  end

  def destroy
    current_user.reset_session_token
    session[:session_token] = nil
    redirect_to new_session_url
  end

  private
  def user_params
    params.require(:user).permit(:name, :password)
  end
end
