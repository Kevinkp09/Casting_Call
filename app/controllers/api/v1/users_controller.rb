class Api::V1::UsersController < ApplicationController
    skip_before_action :doorkeeper_authorize!, only: %i[create login verify_otp credential]
    before_action :check_admin, only: [:view_requests, :reject_request ,:show_approved_agencies, :show_registered_artist]

  def create
    user = User.new(user_params)
    if user.role == "agency"
      user.package = Package.find_or_create_by(name: "starter")
    end
    client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
    return render(json: { error: 'Invalid client ID'}, status: 403) unless client_app
    if user.save
      # create access token for the user, so the user won't need to login again after registration
      access_token = Doorkeeper::AccessToken.create(
        resource_owner_id: user.id,
        application_id: client_app.id,
        refresh_token: generate_refresh_token,
        expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
        scopes: ''
      )

      # return json containing access token and refresh token
      # so that user won't need to call login API right after registration
      render(json: {
        message: 'User created successfully. Check your email for OTP verification',
        user: {
          id: user.id,
          role: user.role,
          email: user.email,
          access_token: access_token.token,
          token_type: 'bearer',
          expires_in: access_token.expires_in,
          refresh_token: access_token.refresh_token,
          created_at: access_token.created_at.to_time.to_i
        }
      })
    else
      render json: { error: 'Invalid user. Please check the provided information.', full_messages: user.errors.full_messages }, status: 422
    end
  end

  def credential
    client_id = Doorkeeper::Application.last.uid
    render json: client_id, status: :ok
  end

  def login
    user = User.find_for_authentication(email: params[:user][:email])
    if user.nil?
      render json: { error: "User not found" }, status: :not_found
      return
    end
    if user&.valid_password?(params[:user][:password])

      client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
      access_token = Doorkeeper::AccessToken.create(
        resource_owner_id: user.id,
        application_id: client_app.id,
        refresh_token: generate_refresh_token,
        expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
        scopes: ''
      )

      render(json: {
        message: 'User login successfully',
        user: {
          id: user.id,
          role: user.role,
          email: user.email,
          access_token: access_token.token,
          username: user.username,
          token_type: 'bearer',
          expires_in: access_token.expires_in,
          refresh_token: access_token.refresh_token,
          created_at: access_token.created_at.to_time.to_i,
        }
      })
    else
      render json: {error: "Invalid email or password" }, status: :unprocessable_entity
    end
  end

  def verify_otp
    user = User.find_by(email: params[:user][:email])
    otp = params[:user][:otp]
    if user && user.otp == otp
      render json: {message: "OTP verified successfully"}, status: :ok
    else
      render json: {message: "Invalid OTP"}, status: :unprocessable_entity
    end
  end

  def show_details
    user = current_user
    render json: {
    user: {
      id: user.id,
      gender: user.gender,
      category: user.category,
      birth_date: user.birth_date,
      current_location: user.current_location,
      skin_color: user.skin_color,
      height: user.height,
      weight: user.weight,
      profile_photo: user.profile_photo.attached? ? url_for(user.profile_photo) : ''
      }
    }, status: :ok
  end

  def find_user
    user = User.find_by(id: doorkeeper_token[:resource_owner_id])
    if user
      render json: {user: user, message:"User rendered successfully"}, status: :ok
    else
      render json: {error: "User not found"}, status: :not_found
    end
  end

  def add_details
    user = current_user
    if user.update(personal_params)
      render json: { message: 'User details updated successfully' }, status: :ok
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def view_requests
    all_requests = User.where(role: :agency).order(created_at: :desc)
    if all_requests
      requests_data = all_requests.map do |agency|
        package_name = agency.package.name if agency.package.present?
        {
          id: agency.id,
          username: agency.username,
          email: agency.email,
          package_name: package_name,
          mobile_no: agency.mobile_no
        }
      end
      render json: requests_data, status: :ok
    else
      render json: { error: "No request present" }, status: :not_found
    end
  end

  def reject_request
    user = User.find(params[:user_id])
    if user.approval_status == "rejected"
      render json: {error: "User is already rejected, it can't be done again"}, status: :unprocessable_entity
    end
    if user.update(approval_status: :rejected)
      user.destroy
      render json: {message: "Agency successfully rejected and removed."}, status: :ok
    else
      render json: {error: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def show_approved_agencies
    users = User.where(role: :agency).map { |user| { user: user, package_name: user.package&.name } }
    render json: users, status: :ok
  end

  def show_registered_artist
    user = User.where(role: :artist).order(created_at: :desc)
    render json: user, status: :ok
  end

  def upgrade_basic
    user = current_user
    package = user.package
    if user.role == "agency"
      if package && package.name == "starter" && package.update(name: "basic", posts_limit: 5, requests_limit: nil)
        render json: { message: "Your package has been updated to basic successfully" }, status: :ok
      else
        render json: { error: package.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: {error: "You are unauthorized for this action"}, status: :unauthorized
    end
  end

  def upgrade_advance
    if user.role == "agency"
      user = current_user
      package = user.package
      if (package.name == "starter" || package.name == "basic") && package.update(name: "advance", posts_limit: nil, requests_limit: nil)
        render json: {message: "Your package has been updated to advance successfully"}, status: :ok
      else
        render json: {error: package.errors.full_messages}, status: unprocessable_entity
      end
    else
      render json: {error: "You are unauthorized for this action"}, status: :unauthorized
    end
  end

  def filter_starter
    starter_users = User.includes(:package).where(packages: {name: "starter"})
    render json: starter_users, status: :ok
  end

  def filter_basic
    basic_users = User.includes(:package).where(packages: {name: "basic"})
    render json: basic_users, status: :ok
  end

  def filter_advance
    advance_users = User.includes(:package).where(packages: {name: "advance"})
    render json: advance_users, status: :ok
  end

  def view_profile
    user = User.find(params[:user_id])
    works = user.works
    render json:{
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        role: user.role,
        skin_color: user.skin_color,
        height: user.height,
        weight: user.weight,
        gender: user.gender,
        category: user.category,
        birth_date: user.birth_date,
        current_location: user.current_location,
        profile_photo: user.profile_photo.attached? ? url_for(user.profile_photo) : ''
      }, works: works.map{|work| work.attributes}
    }, status: :ok

  end

  def forgot
    user = User.find_by(email: params[:email])
    if user
      otp = generate_otp
      user.update(otp: otp)
      UserMailer.forgot_password_email(user, otp).deliver_now
      render json: { message: "OTP has been sent to your email" }, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def reset
    user = User.find_by(email: params[:email])
    if user && user.otp == params[:otp]
      user.update(password: params[:password], otp: nil)
      render json: { message: "Password reset successfully" }, status: :ok
    else
      render json: { error: "Invalid OTP" }, status: :unprocessable_entity
    end
  end
  private

  def user_params
    params.require(:user).permit(:email, :password, :username, :mobile_no, :role, :otp, :posts_count)
  end

  def personal_params
    params.require(:user).permit(:gender, :category, :birth_date, :current_location, :profile_photo, :skin_color, :height, :weight)
  end

  def generate_refresh_token
    loop do
      # generate a random token string and return it,
      # unless there is already another token with the same string
      token = SecureRandom.hex(32)
      break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
    end
  end

  def check_admin
    unless current_user && current_user.role == "admin"
      render json: {error: "You are unauthorized"}, status: :unauthorized
    end
  end

  def generate_otp
    rand.to_s[2..5]
  end
end
