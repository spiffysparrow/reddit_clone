class PostsController < ApplicationController
  before_action :require_author, only: [:edit, :update]

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id if current_user
    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.messages
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.messages
      render :edit
    end
  end

  def require_author
    @post = Post.find(params[:id])
    if current_user.nil?
      flash[:errors] = "Can't update post without being logged in"
      redirect_to new_session_url
    elsif current_user.id != @post.user_id
      flash[:errors] = "Can't edit another user's post."
      redirect_to post_url(@post)
    end
  end


  private
  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id)
  end
end
