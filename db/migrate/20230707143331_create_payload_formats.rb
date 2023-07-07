# frozen_string_literal: true

class CreatePayloadFormats < ActiveRecord::Migration[7.0]
  def change
    create_table :payload_formats do |t|
      t.json :schema
      t.string :provider

      t.timestamps
    end
  end
end
