class CreateCertificates < ActiveRecord::Migration[5.1]
  def change
    create_table :certificates do |t|
      t.references :metadatum, foreign_key: true
      t.text :pem
      t.text :private_key_pem
      t.string :use
    end
  end
end
