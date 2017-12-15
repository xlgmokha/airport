class IdentityProvidersController < ApplicationController
  def index
    @metadatum = Metadatum.identity_providers.limit(10)
  end

  def show
    metadatum = Metadatum.find(params[:id])
    render xml: metadatum.to_xml
  end

  def new
  end

  def create
    Saml::Kit.registry.register_url(params[:url], verify_ssl: Rails.env.production?)
  end

  def update
    metadatum = Metadatum.find(params[:id])
    Saml::Kit.registry.register_url(metadatum.url, verify_ssl: Rails.env.production?)
    redirect_to identity_providers_path
  end

  def destroy
    metadatum = Metadatum.find(params[:id])
    metadatum.destroy!
    redirect_to identity_providers_path
  end
end
