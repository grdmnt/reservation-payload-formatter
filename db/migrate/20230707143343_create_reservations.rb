# frozen_string_literal: true

class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.string :code
      t.date :start_date
      t.date :end_date
      t.integer :nights_count, default: 0
      t.integer :total_guests_count, default: 0
      t.integer :adults_count, default: 0
      t.integer :children_count, default: 0
      t.integer :infants_count, default: 0
      t.string :status
      t.string :host_currency
      t.integer :payout_price_cents, default: 0
      t.integer :security_price_cents, default: 0
      t.integer :total_price_cents, default: 0
      t.references :guest, null: false, foreign_key: true
      t.references :payload_format, null: false, foreign_key: true

      t.timestamps
    end
  end
end
