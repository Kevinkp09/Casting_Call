class Api::V1::PostsController < ApplicationController
  before_action :approved_agency, only: [:create, :show_posts]

  def index
    if current_user.role == "artist"
      posts = Post.all
      render json: posts, status: :ok
    end
  end

  def show_posts
    posts = current_user.posts
    render posts, status: :ok
  end

  def create
    post = current_user.posts.new(post_params)
    if post.save
      render json: {message: "Post added successfully"}, status: :ok
    else
      render json: {error: "Error in creating post"}, status: :unprocessable_entity
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :age, :location, :description, :role, :category, :user_id)
  end

  def approved_agency
    current_user.role == "agency" && current_user.approval_status = "approved"
  end
end
