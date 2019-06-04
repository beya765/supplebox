class PostsController < ApplicationController
  before_action :require_user_logged_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  
  def new
  end

  def create
    @product = Product.find(params[:post][:product_id])
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = '口コミを投稿しました'
      redirect_to @product
    else
      flash.now[:danger] = '口コミの投稿に失敗しました'
      render 'products/show'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      flash[:success] = '口コミを削除しました'
      redirect_back(fallback_location: root_path)
    end
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:success] = '口コミを更新しました'
      redirect_to @post.product
    else
      flash.now[:danger] = '口コミの編集に失敗しました'
      render :edit
    end
  end
  
  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).order(created_at: :desc).page(params[:page])
  end
  
  private
  
  def post_params
    params.require(:post).permit(:title, :rate, :content, :picture, :product_id)
  end
  
  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to posts_path if @post.nil?
  end
end
