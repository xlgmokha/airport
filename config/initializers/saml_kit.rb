Saml::Kit.configure do |configuration|
  configuration.entity_id = ENV['ISSUER']
  configuration.registry = Metadatum
  configuration.generate_key_pair_for(use: :signing)
  configuration.generate_key_pair_for(use: :encryption)
end
