class Api::V1::PerformanceController < ApplicationController
  before_action :set_performance, only: [:update, :destory]

  def index
    user = current_user
    performances = user.works.includes(:performances).flat_map(&:performances)
    performance_details = performances.map do |performance|
      {
        id: performance.id,
        video_link: performance.video_link,
        youtube_link: performance.youtube_link
      }
    end
    render json: { performances: performance_details }, status: :ok
  end

  def create
    performance = Performance.new(performance_params)
    if performance.save
      render json: {message: "Link added successfully"}, status: :created
    else
      render json: {error: performance.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    if @performance.update(performance_params)
      render json: {message: "Link updated successfully"}, status: :ok
    else
      render json: {error: @performance.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    if @performance.destroy
      render json: {message: "Link deleted successfully", performance: @performance}, status: :ok
    else
      render json: {error: @performance.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def performance_params
    params.require(:performance).permit(:video_link, :audition_link)
  end

  def set_performance
    @performance = Performance.find(params[:id])
    unless @performance
      render json: {error: @performance.errors.full_messages}, status: :not_found
    end
  end
end
