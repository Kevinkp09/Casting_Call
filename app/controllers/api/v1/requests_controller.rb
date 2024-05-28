class Api::V1::RequestsController < ApplicationController
  before_action :set_post, only: [:create]
  before_action :check_request_status, only: [:approve_artist, :reject_artist]
  def index
    user = current_user
    package = user.package
    requests = user.posts.map do |post|
      post.requests.order(id: :asc).map do |r|
        if package.name == "starter"
          {
            id: r.id,
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
    end.flatten
    requests = requests.take(package.requests_limit) unless package.requests_limit.nil?
    render json: { requests: requests, message: "This is the limit." }, status: :ok
  end

  def create
    if current_user.role == "artist"

      binding.pry

      request = @post.requests.new(user: current_user)

      binding.pry
      
      if request.save
        request.update(apply_status: :applied)
        render json: request, status: :created
      else
        render json: {error: request.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {error: "You are unauthorized for this action"}, status: :unauthorized
    end
  end

  def filter_shortlisted
    user = current_user
    package = user.package
    shortlisted_requests = user.posts.map do |post|
      post.requests.where(status: :shortlisted).map do |r|
        if package.name == "starter"
           {
            id: r.user.id,
            username: r.user.username,
            category: r.user.category,
            location: r.user.current_location,
            gender: r.user.gender,
            status: r.status,
            post_title: r.post.title
          }
        end
        r.attributes.merge(user: r.user, post_title: r.post.title)
      end
    end
    render json: shortlisted_requests, status: :ok
  end

  def approve_artist
    if @request.update(status: :shortlisted)
      render json: {message: "Request is shortlisted", id: @request.id, status: @request.status}, status: :ok
    else
      render json: {error: @request.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def reject_artist
    if @request.update(status: :rejected)
      render json: {message: "Request is rejected", id: @request.id, status: @request.status}, status: :ok
    else
      render json: {error: @request.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private
  def request_params
    params.require(:request).permit(:status, :apply_status, :link)
  end

  def set_post
    @post = Post.find(params[:post_id])
    if @post.nil?
      render json: {message: "Post not found"}, status: 404
      return
    end
  end

  def check_request_status
    @request = Request.find_by(id: params[:id])
    if @request.nil?
      render json: {message: "Request not found"}, status: 404
      return
    end
    if @request.status == "shortlisted" || @request.status == "rejected"
      render json: {error: "Request is already shortlisted or rejected, it can't be done again"}, status: :unprocessable_entity
    end
  end
end
