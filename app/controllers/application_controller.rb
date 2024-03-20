class ApplicationController < ActionController::API
  before_action :doorkeeper_authorize!
  include Rails.application.routes.url_helpers
  def current_user
      @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id]) if doorkeeper_token
  end
end
