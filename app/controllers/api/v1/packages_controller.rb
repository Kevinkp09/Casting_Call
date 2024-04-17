class Api::V1::PackagesController < ApplicationController
  def index
    packages = Package.all
    render json: {packages: packages, message: "All packages showing"}, status: :ok
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

  def upgrade_basic
    user = current_user
    package = user.package
    if package.name == "starter" && package.update(name: "basic", posts_limit: 5, requests_limit: nil)
      render json: { message: "Your package has been updated to basic successfully" }, status: :ok
    else
      render json: { error: package.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def upgrade_advance
    user = current_user
    package = user.package
    if (package.name == "starter" || package.name == "basic") && package.update(name: "advance", posts_limit: nil, requests_limit: nil)
      render json: {message: "Your package has been updated to advance successfully"}, status: :ok
    else
      render json: {error: package.errors.full_messages}, status: unprocessable_entity
    end
  end

  private
  def package_params
    params.require(:package).permit(:name, :price)
  end
end
