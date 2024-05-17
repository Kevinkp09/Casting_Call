require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe 'GET /api/v1/posts' do
    let(:user) { FactoryBot.create(:user, role: :artist) }
    let(:agency) { FactoryBot.create(:user, role: :agency) }
    let(:application) { FactoryBot.create(:oauth_application) }
    before do
      sign_in user
      @access_token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, token: '1234567890')
    end

    context 'when user is an artist' do
      it 'returns a list of posts' do
        get "/api/v1/posts", headers: { Authorization: "Bearer #{@access_token.token}" }
        expect(response).to have_http_status(:ok)
      end
    end
  end
  describe "GET /api/v1/posts/show_posts" do
    let(:agency) { FactoryBot.create(:user, role: :agency) }
    let(:user) { FactoryBot.create(:user, role: :artist) }
    let(:application) { FactoryBot.create(:oauth_application) }
    before do
      sign_in agency
      @access_token = Doorkeeper::AccessToken.create!(resource_owner_id: agency.id, application_id: application.id, token: '1234567890')
    end
    context 'when the user is an agency and agency_id is provided' do
      it 'returns a list of posts for the specified agency' do
        get "/api/v1/posts/show_posts", params: { agency_id: agency.id }, headers: { Authorization: "Bearer #{@access_token.token}" }
        expect(response).to have_http_status(:ok)
      end
    end
    context 'when the user is not an agency' do
      before do
        sign_in user
        @access_token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, token: '1234567890')
      end
      it 'returns unauthorized status' do
        get "/api/v1/posts/show_posts", params: { agency_id: agency.id }, headers: { Authorization: "Bearer #{@access_token.token}" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context 'when agency_id is not provided' do
      it 'returns unprocessable entity status' do
        get "/api/v1/posts/show_posts", headers: { Authorization: "Bearer #{@access_token.token}" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  describe "GET /api/v1/posts/:post_id/show_requests" do
    let(:user) { FactoryBot.create(:user, role: :agency) }
    let(:post) { FactoryBot.create(:post, agency: user) }
    let(:application) { FactoryBot.create(:oauth_application) }
    let(:package) { FactoryBot.create(:package, name: 'starter') }

    context "when the user is authorized and package is starter" do
      before do
        sign_in user
        user.update!(package: package)
        @access_token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, token: '1234567890')
      end
      it 'returns requests with limited information' do
        get "/api/v1/posts/#{post.id}/show_requests",  headers: { Authorization: "Bearer #{@access_token.token}" }
        expect(response).to have_http_status(:ok)
      end
    end
  end
  context "when the user is authorized and the package is other than starter" do
    let(:user) { FactoryBot.create(:user, role: :agency) }
    let(:package) { FactoryBot.create(:package, name: "basic") }
    let(:application) { FactoryBot.create(:oauth_application) }
    let(:post) { FactoryBot.create(:post, agency: user) }
    before do
      sign_in user
      user.update!(package: package)
      @access_token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, token: '1234567890')
    end
    it "returns requests with complete information" do
      get "/api/v1/posts/#{post.id}/show_requests", headers: { Authorization: "Bearer #{@access_token.token}" }
      expect(response).to have_http_status(:ok)
    end
  end
  context "when the user is unauthorized" do
    let(:post) { FactoryBot.create(:post, agency: user) }
    let(:user) { FactoryBot.create(:user, role: :agency) }
    it 'returns unauthorized status' do
      get "/api/v1/posts/#{post.id}/show_requests"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
