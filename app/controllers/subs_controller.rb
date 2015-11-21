class SubsController < ApplicationController
  before_action :require_moderator, only: [:edit, :update]

  def show
    @sub = Sub.find(params[:id])
  end

  def new
    @sub = Sub.new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.user_id = current_user.id if current_user

    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.messages
      render :new
    end
  end

  def edit
    @sub = Sub.find(params[:id])
  end

  def update
    @sub = Sub.find(params[:id])
    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      render :edit
    end
  end

  def require_moderator
    @sub = Sub.find(params[:id])
    
    if current_user.nil?
      flash[:errors] = ["Login to edit sub!"]
      redirect_to new_session_url
    elsif @sub.user_id != current_user.id
      flash[:errors] = ["Can't edit another user's subs."]
      redirect_to sub_url(@sub)
    end
  end

  private

  def sub_params
    params.require(:sub).permit(:title, :description)
  end
end
