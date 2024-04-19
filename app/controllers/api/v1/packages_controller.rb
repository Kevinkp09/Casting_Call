class Api::V1::PackagesController < ApplicationController
  def index
    packages = Package.all.order(:price)
    render json: packages, status: :ok
  end

  def update
    if current_user.role == "admin"
      package = Package.find(params[:id])
        if package.update(package_params)
          render json: {package: package, message: "Package updated successfully"}, status: :ok
        else
          render json: {error: package.errors.full_messages}, status: :unprocessable_entity
        end
    else
      render json: {error: "You are not authorized for this action"}, status: :unauthorized
    end
  end

  def destroy
    if current_user.role == "admin"
      package = Package.find(params[:id])
      if package.destroy
        render json: {message: "Package destroyed successfully"}, status: :ok
      else
        render json: {error: package.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {error: "You are not authorized for this action"}, status: :unauthorized
    end
  end
  
  private
  def package_params
    params.require(:package).permit(:name, :price, :posts_limit, :requests_limit)
  end
end
