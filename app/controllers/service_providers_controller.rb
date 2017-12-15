class ServiceProvidersController < ApplicationController
  def index
    @service_providers = Metadatum.service_providers.limit(10)
  end

  def show
    entity_id = service_provider_url(id: params[:id])
    xml = Metadatum.metadata_for(entity_id).to_xml
    render xml: xml, content_type: "application/samlmetadata+xml"
  end

  def new
  end

  def create
    configuration = Saml::Kit::Configuration.new do |config|
      config.issuer = service_provider_url(id: SecureRandom.uuid)
      params[:signing_certificates].to_i.times do |n|
        config.generate_key_pair_for(use: :signing)
      end
      params[:encryption_certificates].to_i.times do |n|
        config.generate_key_pair_for(use: :encryption)
      end
    end
    metadata = Saml::Kit::ServiceProviderMetadata.build(configuration: configuration) do |builder|
      builder.sign = false
      builder.add_assertion_consumer_service(consume_url, binding: :http_post)
      builder.add_single_logout_service(logout_url, binding: :http_post)
    end
    Metadatum.register(metadata)
    redirect_to service_providers_path
  end

  def destroy
    Metadatum.find(params[:id]).destroy!
    redirect_to service_providers_path
  end
end
