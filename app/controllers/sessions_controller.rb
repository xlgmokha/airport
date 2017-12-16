class SessionsController < ApplicationController
  def new
    @metadatum = Metadatum.all
  end

  def create
    @uri, @saml_params = idp.login_request_for(binding: binding_type, relay_state: relay_state) do |builder|
      @saml_builder = builder
      builder.issuer = params[:issuer] if params[:issuer].present?
      builder.assertion_consumer_service_url = callback_url
    end
  end

  def destroy
    @url, @saml_params = idp.logout_request_for(current_user, binding: :http_post, relay_state: relay_state) do |builder|
      @saml_builder = builder
    end
  end

  private

  def idp(entity_id = params[:entity_id])
    Saml::Kit.registry.metadata_for(entity_id)
  end

  def sp(issuer = params[:issuer])
    Saml::Kit.registry.metadata_for(issuer) || Sp.default(request)
  end

  def relay_state
    JSON.generate(redirect_to: '/', issuer: sp.entity_id)
  end

  def binding_type
    :http_redirect == params[:binding].to_sym ? :http_redirect : :http_post
  end

  def callback_url
    sp.assertion_consumer_service_for(binding: :http_post).location
  end
end
