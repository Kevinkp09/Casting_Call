class Api::V1::PostsController < ApplicationController
  before_action :approved_agency, only: [:create, :show_posts]
  before_action :set_post, only: [:update, :destroy, :show]

  def index
    if current_user.role == "artist"
      posts = Post.all
      render json: posts, status: :ok
    end
  end

  def show
    requests = @post.requests.map{|r| r.attributes.merge({user: r.user})}
    render json: requests, status: :ok
  end

  def show_posts
    if params[:agency_id].present?
      posts = Post.where(agency_id: params[:agency_id])
      render json: posts, status: :ok
    else
      render json: {error: "Not found"}, status: 404
    end
  end

  def create
    post = Post.new(post_params)
    post.agency = current_user
    if post.save
      render json: {id: post.id, message: "Post added successfully"}, status: :ok
    else
      render json: {error: post.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    if @post.user == current_user && @post.update(post_params)
      render json: {message: "Post is updated successfully"}, status: :ok
    else
      render json: {error: @post.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.user == current_user && @post.destroy
      render json: {message: "Post deleted successfully"}, status: :ok
    else
      render json: {error: @post.errors.full_messages}, status: :unprocessable_entity
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

  def approved_agency
     unless current_user.role == "agency" && current_user.approval_status == "approved"
       render json: {error: "You are not authorized for this action"}, status: :unauthorized
     end
  end
end
