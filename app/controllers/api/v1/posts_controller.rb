class Api::V1::PostsController < ApplicationController
  before_action :set_post, only: [:update, :destroy, :show]

  def index
    if current_user.role == "artist"
      posts = Post.all.order(created_at: :desc)
      render json: posts, status: :ok
    end
  end

  def show
    requests = @post.requests.order(created_at: :desc).map{|r| r.attributes.merge({user: r.user})}
    user = current_user
    package = user.package
    if package.name == "starter"
      render json: {requests: requests.last(5).reverse, message: "This is the limit."}, status: :ok
    else
      render json: requests, status: :ok
    end
  end

  def show_posts
    if params[:agency_id].present?
      posts = Post.where(agency_id: params[:agency_id]).order(created_at: :desc)
      render json: posts, status: :ok
    else
      render json: {error: "Not found"}, status: 404
    end
  end

  def create
    user = current_user
    package = user.package
    if user.posts.count >= package.posts_limit
      render json: { error: "You need to upgrade your package to create more posts" }, status: :unprocessable_entity
      return
    end
    post = Post.new(post_params)
    post.agency = user

    if post.save
      render json: { id: post.id, message: "Post added successfully" }, status: :created
    else
      render json: { error: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @post.agency == current_user && @post.update(post_params)
      render json: {message: "Post is updated successfully"}, status: :ok
    else
      render json: {error: @post.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.agency == current_user
      if @post.requests.destroy_all && @post.destroy
        render json: {message: "Post deleted successfully"}, status: :ok
      else
        render json: {error: @post.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {message: "You are not the owner of this post"}, status: :unauthorized
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :age, :location, :description, :role, :category)
  end

  def set_post
    @post = Post.find(params[:id])
    if @post.nil?
      render json: {message: "Post not found"}, status: 404
      return
    end
  end

end
