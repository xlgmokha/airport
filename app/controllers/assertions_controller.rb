class AssertionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

  def create
    saml_binding = sp.assertion_consumer_service_for(binding: :http_post)
    @saml_response = saml_binding.deserialize(params, configuration: current_configuration)
    logger.debug(@saml_response.to_xml(pretty: true))
    return render :error, status: :forbidden if @saml_response.invalid?

    session[@saml_response.issuer] = { id: @saml_response.name_id }.merge(@saml_response.attributes)
  end

  def destroy
    if params['SAMLRequest'].present?
      # IDP initiated logout
    elsif params['SAMLResponse'].present?
      saml_binding = sp.single_logout_service_for(binding: :http_post)
      @saml_response = saml_binding.deserialize(params, configuration: current_configuration)
      raise ActiveRecord::RecordInvalid.new(@saml_response) if @saml_response.invalid?
      session[@saml_response.issuer] = nil
    end
  end

  private

  def sp
    default_sp = Sp.default(request)
    if default_sp.entity_id == relay_state[:issuer]
      default_sp
    else
      Metadatum.find_by(entity_id: relay_state[:issuer]).to_saml
    end
  end

  def relay_state
    if params[:RelayState].present?
      JSON.parse(CGI.unescape(params[:RelayState])).with_indifferent_access
    else
      {}
    end
  end

  def current_configuration
    if sp == Sp.default(request)
      Saml::Kit.configuration
    else
      Metadatum.find_by(entity_id: relay_state[:issuer]).configuration
    end
  end
end
