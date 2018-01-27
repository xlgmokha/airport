class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :current_user?

  def current_user(entity_id = params[:entity_id])
    return nil unless session[entity_id].present?
    User.new(session[entity_id].with_indifferent_access)
  end

  def current_user?(entity_id)
    current_user(entity_id).present?
  end
end
