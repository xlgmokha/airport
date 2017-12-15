class Metadatum < ApplicationRecord
  scope :service_providers, -> { where('metadata like ?', '%SPSSODescriptor%') }
  scope :identity_providers, -> { where('metadata like ?', '%IDPSSODescriptor%') }

  def to_xml
    metadata
  end

  def to_saml
    Saml::Kit::Metadata.from(metadata)
  end

  class << self
    def register_url(url, verify_ssl: true)
      content = Saml::Kit::DefaultRegistry::HttpApi.new(url, verify_ssl: verify_ssl).get
      register(Saml::Kit::Metadata.from(content), url: url)
    end

    def register(metadata, url: nil)
      record = Metadatum.find_or_create_by!(entity_id: metadata.entity_id)
      record.url = url
      record.metadata = metadata.to_xml
      record.save!
      metadata
    end

    def metadata_for(entity_id)
      Metadatum.find_by!(entity_id: entity_id).to_saml
    rescue ActiveRecord::RecordNotFound => error
      Rails.logger.error(error)
      nil
    end
  end
end
