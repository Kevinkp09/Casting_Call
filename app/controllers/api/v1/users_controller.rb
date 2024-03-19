class Api::V1::UsersController < ApplicationController
    skip_before_action :doorkeeper_authorize!, only: %i[create login]

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
          message: 'User created successfully',
          user: {
            id: user.id,
            email: user.email,
            access_token: access_token.token,
            token_type: 'bearer',
            expires_in: access_token.expires_in,
            refresh_token: access_token.refresh_token,
            created_at: access_token.created_at.to_time.to_i
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
            email: user.email,
            access_token: access_token.token,
            token_type: 'bearer',
            expires_in: access_token.expires_in,
            refresh_token: access_token.refresh_token,
            created_at: access_token.created_at.to_time.to_i
          }
        })
      else
        render json: {error: "Invalid email or password",full_messages: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show_details
      user = current_user
      render json: {
      # user: {
      #   id: user.id,
      #   gender: user.gender,
      #   category: user.category,
      #   birth_date: user.birth_date,
      #   current_location: user.current_location,
      #   profile_photo: url_for(user.profile_photo)
      #   }
      user: user
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

  def work_details
    user = current_user
    youtube_link = params[:user][:youtube_link]
    youtube_regex = User::VALID_MOBILE_REGEX

    if youtube_link.match?(youtube_regex)
      if user.update(work_params)
        render json: {message: "Work details successfully added"}
      else
        render json: {error: user.errors.full_messages}, status: :unprocessable_entity
      end
    else
        render json: { error: 'Invalid YouTube link' }, status: :unprocessable_entity
    end
  end

  def show_work
    user = current_user
    render json: {
      user: {
        id: user.id,
        project_name: user.project_name,
        artist_role: user.artist_role,
        year: user.year,
        youtube_link: user.youtube_link
        }
      }, status: :ok
  end

    private

    def user_params
      params.require(:user).permit(:email, :password, :username, :mobile_no, :role, :audition_posts)
    end

    def personal_params
      params.require(:user).permit(:gender, :category, :birth_date, :current_location, :profile_photo)
    end

    def work_params
      params.require(:user).permit(:project_name, :year, :youtube_link, :artist_role)
    end

    def generate_refresh_token
      loop do
        # generate a random token string and return it,
        # unless there is already another token with the same string
        token = SecureRandom.hex(32)
        break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
      end
    end
  end
