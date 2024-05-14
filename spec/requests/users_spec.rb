require 'rails_helper'
RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:oauth_application) }
  let(:personal_params) { FactoryBot.attributes_for(:user) }
  describe "POST /api/v1/users" do
    context "with valid parameters" do
      it "creates a new user" do
         post "/api/v1/users", params: { user: FactoryBot.attributes_for(:user), client_id: application.uid}
        expect(response).to have_http_status(200)
      end
    end
    context "with invalid parameters" do
      it "returns an error message" do
        post "/api/v1/users", params: { user: { email: "", password: "password" }, client_id: application.uid }
        expect(response).to have_http_status(422)
      end
    end
  end
  describe "POST /api/v1/users/login" do
    context "with valid credentials" do
      it "logs in the user and returns access token" do
        post "/api/v1/users/login", params: { user: { email: user.email, password: user.password }, client_id: application.uid }
        expect(response).to have_http_status(200)
      end
    end
    context "with invalid credentials" do
      it "returns an error message" do
        post "/api/v1/users/login", params: { user: { email: "invalid@example.com", password: "invalid_password" }, client_id: application.uid }
        expect(response).to have_http_status(404)
      end
      it "returns an error message with status code 422" do
        post "/api/v1/users/login", params: { user: { email: user.email, password: "invalid_password" }, client_id: application.uid }
        expect(response).to have_http_status(422)
      end
    end
  end
  describe "POST /api/v1/users/verify_otp" do
    context "with otp verification" do
      before do
        user.update(otp: "123456", otp_generated_time: Time.now)
      end
      it "verifies the otp successfully" do
        post "/api/v1/users/verify_otp", params: {user: { email: user.email, otp: "123456" }}
        expect(response).to have_http_status(200)
      end
      it "returns an error message for invalid otp" do
        post "/api/v1/users/verify_otp", params: { user: { email: user.email, otp: '654321' } }
        expect(response).to have_http_status(422)
      end
      it "returns an error message for expired OTP" do
        user.update(otp_generated_time: 5.minutes.ago)
        post "/api/v1/users/verify_otp", params: { user: { email: user.email, otp: '123456' } }
        expect(response).to have_http_status(422)
      end
    end
  end
  describe "PUT /api/v1/users/add_details" do
    context "with valid personal params" do
      before do
        sign_in user
        @access_token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, token: '1234567890')
      end
      it 'updates the user details' do
        put "/api/v1/users/add_details", params: { user: personal_params }, headers: { Authorization: "Bearer #{@access_token.token}" }
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with invalid personal params' do
      before do
        sign_in user
        @access_token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, token: '1234567890')
        allow_any_instance_of(User).to receive(:save).and_return(false)
      end
      it 'returns an unprocessable entity status' do
        put "/api/v1/users/add_details",  params: { user: { height: 'Invalid'} }, headers: { Authorization: "Bearer #{@access_token.token}" }
        expect(response).to have_http_status(422)
      end
    end
    context 'when not signed in' do
      it 'returns an unauthorized status' do
        put "/api/v1/users/add_details", params: { user: personal_params }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  describe "GET /api/v1/users/show_details " do
    context "with valid params" do
      before do
        sign_in user
        @access_token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, token: "1234567890")
      end
      it "shows users personal details" do
        get "/api/v1/users/show_details", params: {user: personal_params},  headers: {Authorization: "Bearer #{@access_token.token}"}
      end
    end
  end
  describe "GET /api/v1/users/view_requests" do
    context "when user is an admin" do
      let(:user) { create(:user, role: :admin) }
      before do
        sign_in user
        @access_token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, token: "1234567890")
      end
      it 'returns a success response' do
        get "/api/v1/users/view_requests", headers: {Authorization: "Bearer #{@access_token.token}"}
        expect(response).to have_http_status(:ok)
      end
    end
    context 'when user is not an admin' do
      let(:non_admin_user) { create(:user, role: :artist) }
      before do
        sign_in non_admin_user
      end
      it 'returns an unauthorized response' do
        get "/api/v1/users/view_requests"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  describe "PUT /api/v1/users/:user_idreject_request" do
    context "when user is an admin" do
      let(:user) { create(:user, role: :admin) }
      let(:agency_user) { create(:user, role: :agency) }
      before do
        sign_in user
        @access_token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, token: "1234567890")
      end
      it 'rejects and removes the agency successfully' do
        put "/api/v1/users/#{agency_user.id}reject_request", params: { user_id: agency_user.id }, headers: {Authorization: "Bearer #{@access_token.token}"}
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
