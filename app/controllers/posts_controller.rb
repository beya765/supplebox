class PostsController < ApplicationController
  before_action :require_user_logged_in
  
  def new
  end

  def create
    @product = Product.find(params[:post][:product_id])
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = '口コミを投稿しました'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
  end

  def show
    @post = Post.find(params[:id])
    @product = Product.find(@post.product_id)
    @user = User.find(@post.user_id)
  end
  
  private
  
  def post_params
    params.require(:post).permit(:title, :rate, :content, :picture, :product_id)
  end
end
