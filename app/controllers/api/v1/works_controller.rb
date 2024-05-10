class Api::V1::WorksController < ApplicationController
  def index
    user = current_user
    works = user.works.order(created_at: :desc)
    response = works.map do |work|
      {
        id: work.id,
        project_name: work.project_name,
        artist_role: work.artist_role,
        year: work.year,
        youtube_link: work.youtube_link,
        images: work.images.map { |image| url_for(image) }
      }
    end
    render json: response, status: :ok
  end

  def create
    user = current_user
    work = user.works.new(work_params)
    if work.save
      render json: {message: "Work details added successfully"}, status: :ok
    else
      render json: {error: work.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    work = Work.find(params[:id])
    if work.user == current_user
      if work.update(work_params)
        render json: {message: "Work details updated succesfully"}, status: :ok
      else
        render json: {error: work.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {message: "You are unauthorized for this action"}, status: :unauthorized
    end
  end

  def destroy
    work = Work.find(params[:id])
    if work.user == current_user
      if work.destroy
          render json: {message: "Work details deleted successfully"}, status: :ok
      else
          render json: {error: work.errrors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {message: "You are unauthorized for this action"}, status: :unauthorized
    end
  end

  private

  def work_params
    params.require(:work).permit(:project_name, :year, :youtube_link, :artist_role, :images)
  end
end
