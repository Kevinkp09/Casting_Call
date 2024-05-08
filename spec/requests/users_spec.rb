require 'rails_helper'
RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:oauth_application) }
  describe "POST /api/v1/users" do
    context "with valid parameters" do
      it "creates a new user" do
         post "/api/v1/users", params: { user: FactoryBot.attributes_for(:user), client_id: application.uid}
        expect(response).to have_http_status(200)
      end
    end
  end
end
