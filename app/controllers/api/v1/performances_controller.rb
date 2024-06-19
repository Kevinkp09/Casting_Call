class Api::V1::PerformancesController < ApplicationController
  before_action :set_performance, only: [:update, :destroy]

  def show_video
    user = current_user
    performances = user.performances
    performance_details = performances.map do |performance|
      {
        id: performance.id,
        video_link: performance.video_link,
      }
    end
    render json: { performances: performance_details }, status: :ok
  end

  def show_audition
    user = current_user
      performances = user.performances
      performance_details = performances.map do |performance|
        {
          id: performance.id,
          video_link: performance.video_link,
        }
      end
    render json: { performances: performance_details }, status: :ok
  end

  def create
    user = current_user
    performance = user.performances.new(performance_params)
    if performance.save
      render json: { message: "Link added successfully", video_link: performance.video_link, audition_link: performance.audition_link }, status: :created
    else
      render json: { error: performance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @performance.update(performance_params)
      render json: {message: "Link updated successfully", video_link: @performance.video_link, audition_link: @performance.audition_link }, status: :ok
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
