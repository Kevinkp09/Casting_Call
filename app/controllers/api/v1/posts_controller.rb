class Api::V1::PostsController < ApplicationController
  before_action :set_post, only: [:update, :destroy, :show]
  before_action :check_agency, only: [:create, :destroy, :show, :show_posts]
  def index
    if current_user.role == "artist"
      posts = Post.all.order(created_at: :desc)
      posts_data = posts.map do |post|
        request_status = current_user.requests.find_by(post_id: post.id)&.apply_status || ''
        approval_status = current_user.requests.find_by(post_id: post.id)&.status || ''
        {
          id: post.id,
          title: post.title,
          description: post.description,
          audition_type: post.audition_type,
          age: post.age,
          location: post.location,
          role: post.role,
          category: post.category,
          skin_color: post.skin_color,
          weight: post.weight,
          height: post.height,
          approval_status: approval_status,
          apply_status: request_status,
          script: post.script.attached? ? url_for(post.script) : ''
        }
      end
      render json: { posts: posts_data }, status: :ok
    end
  end

  def show
   render json: @post, status: :ok
  end

  def show_posts
    if params[:agency_id].present?
      posts = Post.where(agency_id: params[:agency_id]).order(created_at: :desc)
      posts_data = posts.map do |post|
        {
          id: post.id,
          title: post.title,
          description: post.description,
          audition_type: post.audition_type,
          age: post.age,
          location: post.location,
          role: post.role,
          category: post.category,
          skin_color: post.skin_color,
          weight: post.weight,
          height: post.height,
          script: post.script.attached? ? url_for(post.script) : ''
        }
      end
      render json: { posts: posts_data }, status: :ok
    else
      render json: { error: "Agency ID not provided" }, status: :unprocessable_entity
    end
  end

  def create
    user = current_user
    package = user.package
    if user.posts.count >= package.posts_limit.to_i
      render json: { error: "You need to upgrade your package to create more posts" }, status: :unprocessable_entity
      return
    end
    post = Post.new(post_params)
    post.agency = user

    if post.save
      render json: { id: post.id, message: "Post added successfully", script: post.script.attached? ? url_for(post.script) : '' }, status: :created
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
    params.require(:post).permit(:title, :age, :location, :description, :role, :category, :audition_type, :script, :skin_color, :height, :weight)
  end

  def set_post
    @post = Post.find(params[:id])
    if @post.nil?
      render json: {message: "Post not found"}, status: 404
      return
    end
  end

  def check_agency
    unless current_user && current_user.role == "agency"
      render json: {error: "You are unauthorized"}, status: :unauthorized
    end
  end
end
