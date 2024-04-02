class Api::V1::PostsController < ApplicationController
  before_action :approved_agency

  def index
    posts = user.posts
    render json: posts, status: :ok
  end

  def create
    user = current_user
    post = user.posts.new(post_params)
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
    user.role == "agency" && user.approval_status = approved
  end
end
