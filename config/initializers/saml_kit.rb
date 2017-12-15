Saml::Kit.configure do |configuration|
  configuration.issuer = ENV['ISSUER']
  configuration.registry = Metadatum
  configuration.generate_key_pair_for(use: :signing)
  configuration.generate_key_pair_for(use: :encryption)
end
