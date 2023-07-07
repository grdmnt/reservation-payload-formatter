# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    sequence :code do |n|
      "CODE#{n}"
    end
    start_date { Time.zone.now.next_day(5) }
    end_date { Time.zone.now.next_day(8) }
    nights_count { 3 }
    total_guests_count { 4 }
    adults_count { 2 }
    children_count { 1 }
    infants_count { 1 }
    status { 'pending' }
    host_currency { 'AUD' }
    payout_price_cents { 10_000 }
    security_price_cents { 5000 }
    total_price_cents { 15_000 }
    guest
    payload_format
  end
end
