class Api::V1::UsersController < ApplicationController
    skip_before_action :doorkeeper_authorize!, only: %i[create login verify_otp]
    before_action :check_admin, only: [:view_requests, :approve_request, :reject_request ,:show_approved_agencies, :show_registered_artist]

  def create
    user = User.new(user_params)
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
          created_at: access_token.created_at.to_time.to_i,
          otp: user.otp
        }
      })
    else
      render(json: { error: 'Invalid user. Please check the provided information.', full_messages: user.errors.full_messages }, status: 422)
    end
  end

  def login
    user = User.find_for_authentication(email: params[:user][:email])
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
      render json: {error: "Invalid email or password",full_messages: user.errors.full_messages }, status: :unprocessable_entity
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
      profile_photo: user.profile_photo.attached? ? url_for(user.profile_photo) : ''
      }
    }, status: :ok
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
    pending_requests = User.where(approval_status: :pending, role: :agency)
    if pending_requests
     render json: pending_requests, status: :ok
    else
      render json: {error: "No pending request present"}, status: :not_found
    end
  end

  def approve_request
    user = User.find_by(id: params[:user][:id])
      if user.approval_status == "approved" || user.approval_status == "rejected"
        render json: {error: "User is already approved or rejected, it can't be done again"}, status: :unprocessable_entity
      end
      if user.update(approval_status: :approved)
        render json: {message: "Agency is approved"}, status: :ok
      else
        render json: {error: user.errors.full_messages}, status: :unprocessable_entity
      end
  end

  def reject_request
    user = User.find_by(id: params[:user][:id])
    if user.approval_status == "approved" || user.approval_status == "rejected"
      render json: {error: "User is already approved or rejected, it can't be done again"}, status: :unprocessable_entity
    end
    if user.update(approval_status: :rejected)
      render json: {message: "Agency is rejected"}, status: :ok
    else
      render json: {error: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def show_approved_agencies
    user = User.where(approval_status: :approved, role: :agency)
    render json: user, status: :ok
  end

  def show_registered_artist
    user = User.where(role: :artist)
    render json: user, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :username, :mobile_no, :role, :audition_posts, :otp)
  end

  def personal_params
    params.require(:user).permit(:gender, :category, :birth_date, :current_location, :profile_photo)
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
      render json: {error: "You are unauthorized"}, status: :unprocessable_entity
    end
  end
end
