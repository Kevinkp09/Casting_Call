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
          name: post.agency&.username || '',
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
          date: post.date,
          time: post.time,
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

  def show_requests
    user = current_user
    package = user.package
    @post = Post.find(params[:post_id])
    requests = @post.requests.order(id: :asc).map do |r|
      if package.name == "starter"
          {
            id: r.id,
            user_id: r.user.id,
            username: r.user.username,
            category: r.user.category,
            location: r.user.current_location,
            gender: r.user.gender,
            status: r.status
          }
      else
        r.attributes.merge({ user: r.user })
      end
    end
    requests = requests.take(package.requests_limit) unless package.requests_limit.nil?
    render json: {requests: requests, message: "This is the limit."}, status: :ok
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
          date: post.date,
          time: post.time,
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
    if user.posts_count.to_i >= package.posts_limit
      render json: { error: "You need to upgrade your package to create more posts" }, status: :unprocessable_entity
      return
    end
    post = Post.new(post_params)
    post.agency = user
    if post.save
      user.posts_count = user.posts_count.to_i  + 1
      user.save
      render json: { id: post.id, message: "Post added successfully", script: post.script.attached? ? url_for(post.script) : '' }, status: :created
    else
      render json: { error: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)

      binding.pry

      render json: {message: "Post is updated successfully"}, status: :ok
    else
      render json: {error: @post.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.requests.destroy_all && @post.destroy
      render json: {message: "Post deleted successfully"}, status: :ok
    else
      render json: {error: @post.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :age, :location, :description, :role, :category, :audition_type, :script, :date, :time)
  end

  def set_post
    @post = Post.find(params[:id])

    binding.pry

    if @post.agency == current_user
      if @post.nil?
        render json: {message: "Post not found"}, status: 404
        return
      end
    else
      render json: {error: "You are unauthorized for this action"}, status: :unauthorized
    end
  end

  def check_agency
    unless current_user && current_user.role == "agency"
      render json: {error: "You are unauthorized"}, status: :unauthorized
    end
  end
end
