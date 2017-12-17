class Certificate < ApplicationRecord
  belongs_to :metadatum
  scope :signing, ->() { where(use: :signing) }
  scope :encryption, ->() { where(use: :signing) }
end
