# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#
FactoryBot.create(
  :payload_format,
  provider: "Payload #1",
  schema: {
    reservation_code: 'reservation.code',
    start_date: 'reservation.start_date',
    end_date: 'reservation.end_date',
    nights: 'reservation.nights_count',
    guests: 'reservation.total_guests_count',
    adults: 'reservation.adults_count',
    children: 'reservation.children_count',
    infants: 'reservation.infants_count',
    status: 'reservation.status',
    'guest.first_name': 'guest.first_name',
    'guest.last_name': 'guest.last_name',
    'guest.phone': 'guest.phone_numbers',
    'guest.email': 'guest.email',
    currency: 'reservation.host_currency',
    payout_price: 'reservation.payout_price',
    security_price: 'reservation.security_price',
    total_price: 'reservation.total_price'
  }
)

FactoryBot.create(
  :payload_format,
  provider: "Payload #2",
  schema: {
    'reservation.code': 'reservation.code',
    'reservation.start_date': 'reservation.start_date',
    'reservation.end_date': 'reservation.end_date',
    'reservation.expected_payout_amount': 'reservation.payout_price',
    'reservation.guest_details.number_of_adults': 'reservation.adults_count',
    'reservation.guest_details.number_of_children': 'reservation.children_count',
    'reservation.guest_details.number_of_infants': 'reservation.infants_count',
    'reservation.guest_email': 'guest.email',
    'reservation.guest_first_name': 'guest.first_name',
    'reservation.guest_last_name': 'guest.last_name',
    'reservation.guest_phone_numbers': 'guest.phone_numbers',
    'reservation.listing_security_price_accurate': 'reservation.security_price',
    'reservation.host_currency': 'reservation.host_currency',
    'reservation.nights': 'reservation.nights_count',
    'reservation.number_of_guests': 'reservation.total_guests_count',
    'reservation.status_type': 'reservation.status',
    'reservation.total_paid_amount_accurate': 'reservation.total_price'

  }
)
