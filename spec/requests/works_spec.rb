require 'rails_helper'
RSpec.describe "Works", type: :request do
  describe 'POST /api/v1/works' do
    let(:user) { FactoryBot.create(:user) }
    let(:application) { FactoryBot.create(:oauth_application) }
    let(:work) { FactoryBot.create(:work) }
    let(:work_params) { FactoryBot.attributes_for(:work) }
      context 'with valid attributes' do
        before do
          sign_in user
          @access_token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, token: '1234567890')
        end
        it 'creates a new work' do
          post '/api/v1/works', params: { work: work_params }, headers: { Authorization: "Bearer #{@access_token.token}" }
          expect(response).to have_http_status(:ok)
        end
      end
      context 'with invalid attributes' do
        before do
          sign_in user
          @access_token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, token: '1234567890')
          allow_any_instance_of(Work).to receive(:save).and_return(false)
        end
        it 'does not create a new work' do
          post '/api/v1/works', params: { work: work_params,  project_name: '' }, headers: { Authorization: "Bearer #{@access_token.token}" }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        post '/api/v1/works', params: { work: work_params }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  describe 'PUT /api/v1/works/:id' do
    let(:user) { FactoryBot.create(:user, role: 'artist') }
    let(:work) { FactoryBot.create(:work, user: user) }
    let(:application) { FactoryBot.create(:oauth_application) }
    let(:new_attributes) { FactoryBot.attributes_for(:work) }

    context 'with valid attributes' do
      before do
        sign_in user
        @access_token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, token: '1234567890')
      end

      it 'updates the work with valid attributes' do
        put "/api/v1/works/#{work.id}", params: { work: new_attributes }, headers: { Authorization: "Bearer #{@access_token.token}" }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      before do
        sign_in user
        @access_token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, token: '1234567890')
      end

      it 'returns unprocessable entity' do
        allow_any_instance_of(Work).to receive(:save).and_return(false)
        put "/api/v1/works/#{work.id}", params: { work: { project_name: '' } }, headers: { Authorization: "Bearer #{@access_token.token}" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        post '/api/v1/works', params: { work: work_params }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
