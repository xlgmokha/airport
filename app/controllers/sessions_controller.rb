class SessionsController < ApplicationController
  def new
    @metadatum = Metadatum.all
  end

  def create
    if :http_redirect == params[:binding].to_sym
      @uri, @saml_params = idp.login_request_for(binding: :http_redirect, relay_state: relay_state) do |builder|
        @saml_builder = builder
        builder.acs_url = Sp.default(request).assertion_consumer_service_for(binding: :http_post).location
      end
    else
      @uri, @saml_params = idp.login_request_for(binding: :http_post, relay_state: relay_state) do |builder|
        @saml_builder = builder
        builder.acs_url = Sp.default(request).assertion_consumer_service_for(binding: :http_post).location
      end
    end
  end

  def destroy
    @url, @saml_params = idp.logout_request_for(current_user, binding: :http_post, relay_state: relay_state) do |builder|
      @saml_builder = builder
    end
  end

  private

  def idp(entity_id = params[:entity_id])
    Saml::Kit.configuration.registry.metadata_for(params[:entity_id])
  end

  def relay_state
    JSON.generate(redirect_to: '/')
  end
end
