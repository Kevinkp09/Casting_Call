class Api::V1::RequestsController < ApplicationController
  def index
    post = Post.find(params[:post_id])
    requests = post.requests
    render json: requests, status: :ok
  end

  def create
    if current_user.role == "artist"
      post = Post.find(params[:post_id])
      request = post.requests.new(user: current_user)
      if request.save
        render json: request, status: :created
      else
        render json: {error: "Error in creating request"}, status: :unprocessable_entity
      end
    else
      render json: {error: "You are unauthorized for this action"}, status: :unauthorized
    end
  end

  def approve_artist
    request = Request.find(params[:id])
    if request.status == "approved" || request.status == "rejected"
      render json: {error: "Request is already approved or rejected, it can't be done again"}, status: :unprocessable_entity
    end
    if request.update(status: :approved)
      render json: {message: "Request is approved", id: request.id, status: request.status}, status: :ok
    else
      render json: {error: request.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def reject_artist
    request = Request.find(params[:id])
    if request.status == "approved" || request.status == "rejected"
      render json: {error: "Request is already approved or rejected, it can't be done again"}, status: :unprocessable_entity
    end
    if request.update(status: :rejected)
      render json: {message: "Request is rejected", id: request.id, status: request.status}, status: :ok
    else
      render json: {error: request.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private
  def request_params
    params.require(:request).permit(:status)
  end
end
