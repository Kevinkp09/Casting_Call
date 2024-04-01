class Api::V1::PostsController < ApplicationController
  before_action :approved_agency
  def create
    user = current_user
    if user.role == "agency" && user.approval_status == "approved"
      post = user.posts.new(post_params)
      if post.save
        render json: {message: "Post added successfully"}, status: :ok
      else
        render json: {error: "Error in creating post"}, status: :unprocessable_entity
      end
    else
      render json: {error: "You are not authorized for this action"}, status: :unprocessable_entity
    end
  end

  def view_applied_artist
    
  end

  private
  def post_params
    params.require(:post).permit(:title, :age, :location, :description, :role, :category, :user_id)
  end

  def approved_agency
    user.approval_status = approved
  end
end
