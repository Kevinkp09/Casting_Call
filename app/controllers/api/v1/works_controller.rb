class WorksController < ApplicationController
  def index
    works = Work.all
  end

  def create
    work = Work.new(work_params)
    if work.save
      render json: {message: "Work details added successfully"}, status: :ok
    else
      render json: {error: works.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    work = Work.find(params[:id])
    if work.update(work_params)
      render json: {message: "Work details updated succesfully"}, status: :ok
    else
      render json: {error: works.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    work = Work.find(params[:id])
    work.destroy 
  end

  private

  def work_params
    params.require(:work).permit(:project_name, :year, :youtube_link, :artist_role)
  end
end
