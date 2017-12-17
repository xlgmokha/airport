class ProvidersController < ApplicationController
  def index
    @identity_providers = Metadatum.identity_providers.limit(10)
    @service_providers = Metadatum.service_providers.limit(10)
  end
end
