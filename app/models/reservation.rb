# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :guest
  belongs_to :payload_format

  validates :code, uniqueness: true

  monetize :payout_price_cents
  monetize :security_price_cents
  monetize :total_price_cents
end
