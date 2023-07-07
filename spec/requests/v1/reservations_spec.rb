# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Reservations', type: :request do
  describe 'POST v1/reservations' do
    context 'with valid payload #1' do
      let(:payload) do
        {
          reservation_code: 'YYY12345678',
          start_date: '2021-04-14',
          end_date: '2021-04-18',
          nights: 4,
          guests: 4,
          adults: 2,
          children: 2,
          infants: 0,
          status: 'accepted',
          guest: {
            first_name: 'Wayne',
            last_name: 'Woodbridge',
            phone: '639123456789',
            email: 'wayne_woodbridge@bnb.com'
          },
          currency: 'AUD',
          payout_price: '4200.00',
          security_price: '500',
          total_price: '4700.00'
        }.to_json
      end

      let(:guest_attrs) do
        {
          first_name: 'Wayne',
          last_name: 'Woodbridge',
          phone_numbers: ['639123456789'],
          email: 'wayne_woodbridge@bnb.com'
        }
      end

      let(:reservation_attrs) do
        {
          code: 'YYY12345678',
          start_date: Date.parse('2021-04-14'),
          end_date: Date.parse('2021-04-18'),
          nights_count: 4,
          total_guests_count: 4,
          adults_count: 2,
          children_count: 2,
          infants_count: 0,
          status: 'accepted',
          host_currency: 'AUD',
          payout_price_cents: 420_000,
          security_price_cents: 50_000,
          total_price_cents: 470_000
        }
      end

      let(:valid_payload_format) do
        create(
          :payload_format,
          provider: 'payload_1',
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
      end

      let(:invalid_payload_format) do
        create(
          :payload_format,
          provider: 'payload_1',
          schema: {
            some_code: 'reservation.code',
            start_date: 'reservation.start_date',
            end_date: 'reservation.end_at',
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
      end

      let(:request) do
        post '/v1/reservations', params: payload, headers: { 'Content-Type' => 'application/json' }
      end

      before do
        invalid_payload_format
        valid_payload_format
      end

      context 'when with valid params' do
        it 'returns 200' do
          request

          expect(response).to have_http_status(200)
        end

        it 'creates a guest record' do
          expect { request }.to change(Guest, :count).by(1)
        end

        it 'sets the payload data properly to guest' do
          request

          expect(Guest.last).to have_attributes(guest_attrs)
        end

        it 'sets the payload data properly to reservation' do
          request

          expect(Reservation.last).to have_attributes(reservation_attrs)
        end

        it 'creates a reservation record' do
          expect { request }.to change(Reservation, :count).by(1)
        end
      end
    end

    context 'with valid payload #2' do
      let(:payload) do
        {
          reservation: {
            code: 'XXX12345678',
            start_date: '2021-03-12',
            end_date: '2021-03-16',
            expected_payout_amount: '3800.00',
            guest_details: {
              localized_description: '4 guests',
              number_of_adults: 2,
              number_of_children: 2,
              number_of_infants: 0
            },
            guest_email: 'wayne_woodbridge@bnb.com',
            guest_first_name: 'Wayne',
            guest_last_name: 'Woodbridge',
            guest_phone_numbers: %w[
              639123456789
              639123456789
            ],
            listing_security_price_accurate: '500.00',
            host_currency: 'AUD',
            nights: 4,
            number_of_guests: 4,
            status_type: 'accepted',
            total_paid_amount_accurate: '4300.00'
          }
        }.to_json
      end

      let(:guest_attrs) do
        {
          first_name: 'Wayne',
          last_name: 'Woodbridge',
          phone_numbers: %w[639123456789 639123456789],
          email: 'wayne_woodbridge@bnb.com'
        }
      end

      let(:reservation_attrs) do
        {
          code: 'XXX12345678',
          start_date: Date.parse('2021-03-12'),
          end_date: Date.parse('2021-03-16'),
          nights_count: 4,
          total_guests_count: 4,
          adults_count: 2,
          children_count: 2,
          infants_count: 0,
          status: 'accepted',
          host_currency: 'AUD',
          payout_price_cents: 380_000,
          security_price_cents: 50_000,
          total_price_cents: 430_000
        }
      end

      let(:valid_payload_format) do
        create(
          :payload_format,
          provider: 'payload_2',
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
      end

      let(:invalid_payload_format) do
        create(
          :payload_format,
          provider: 'payload_1',
          schema: {
            'reservation.code': 'reservation.code',
            'reservation.start_date': 'reservation.start_date',
            'reservation.end_date': 'reservation.end_date',
            'reservation.expected_payout_amount': 'reservation.payout_price',
            'reservation.guest_details.adults_count': 'reservation.adults_count',
            'reservation.guest_details.children_count': 'reservation.children_count',
            'reservation.guest_details.infants_count': 'reservation.infant_count',
            'reservation.guest_email': 'guest.email',
            'reservation.guest_first_name': 'guest.first_name',
            'reservation.guest_last_name': 'guest.last_name',
            'reservation.guest_phone_numbers': 'guest.phone_numbers',
            'reservation.listing_security_price_accurate': 'reservation.security_price',
            'reservation.host_currency': 'resrevation.host_currency',
            'reservation.nights': 'reservation.nights_count',
            'reservation.status_type': 'reservation.status',
            'reservation.total_paid_amount_accurate': 'reservation.total_price'
          }
        )
      end

      let(:request) do
        post '/v1/reservations', params: payload, headers: { 'Content-Type' => 'application/json' }
      end

      before do
        invalid_payload_format
        valid_payload_format
      end

      context 'when with valid params' do
        it 'returns 200' do
          request

          expect(response).to have_http_status(200)
        end

        it 'creates a guest record' do
          expect { request }.to change(Guest, :count).by(1)
        end

        it 'sets the payload data properly to guest' do
          request

          expect(Guest.last).to have_attributes(guest_attrs)
        end

        it 'sets the payload data properly to reservation' do
          request

          expect(Reservation.last).to have_attributes(reservation_attrs)
        end

        it 'creates a reservation record' do
          expect { request }.to change(Reservation, :count).by(1)
        end
      end
    end

    context 'with creation using payload#1 then update using payload#2' do
      let(:payload1) do
        {
          reservation_code: 'YYY12345678',
          start_date: '2021-04-14',
          end_date: '2021-04-18',
          nights: 4,
          guests: 4,
          adults: 2,
          children: 2,
          infants: 0,
          status: 'accepted',
          guest: {
            first_name: 'Wayne',
            last_name: 'Woodbridge',
            phone: '639123456789',
            email: 'wayne_woodbridge@bnb.com'
          },
          currency: 'AUD',
          payout_price: '4200.00',
          security_price: '500',
          total_price: '4700.00'
        }.to_json
      end
      let(:payload2) do
        {
          reservation: {
            code: 'YYY12345678',
            start_date: '2021-03-12',
            end_date: '2021-03-16',
            expected_payout_amount: '3800.00',
            guest_details: {
              localized_description: '4 guests',
              number_of_adults: 2,
              number_of_children: 2,
              number_of_infants: 0
            },
            guest_email: 'wayne_woodbridge@bnb.com',
            guest_first_name: 'Wayne',
            guest_last_name: 'Woodbridge',
            guest_phone_numbers: %w[
              639123456789
              639123456789
            ],
            listing_security_price_accurate: '500.00',
            host_currency: 'AUD',
            nights: 4,
            number_of_guests: 4,
            status_type: 'accepted',
            total_paid_amount_accurate: '4300.00'
          }
        }.to_json
      end

      let(:guest_attrs) do
        {
          first_name: 'Wayne',
          last_name: 'Woodbridge',
          phone_numbers: %w[639123456789 639123456789],
          email: 'wayne_woodbridge@bnb.com'
        }
      end

      let(:reservation_attrs) do
        {
          code: 'YYY12345678',
          start_date: Date.parse('2021-03-12'),
          end_date: Date.parse('2021-03-16'),
          nights_count: 4,
          total_guests_count: 4,
          adults_count: 2,
          children_count: 2,
          infants_count: 0,
          status: 'accepted',
          host_currency: 'AUD',
          payout_price_cents: 380_000,
          security_price_cents: 50_000,
          total_price_cents: 430_000
        }
      end

      let(:valid_payload_format1) do
        create(
          :payload_format,
          provider: 'payload_1',
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
      end

      let(:valid_payload_format2) do
        create(
          :payload_format,
          provider: 'payload_2',
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
      end

      let(:invalid_payload_format) do
        create(
          :payload_format,
          provider: 'payload_1',
          schema: {
            'reservation.code': 'reservation.code',
            'reservation.start_date': 'reservation.start_date',
            'reservation.end_date': 'reservation.end_date',
            'reservation.expected_payout_amount': 'reservation.payout_price',
            'reservation.guest_details.adults_count': 'reservation.adults_count',
            'reservation.guest_details.children_count': 'reservation.children_count',
            'reservation.guest_details.infants_count': 'reservation.infant_count',
            'reservation.guest_email': 'guest.email',
            'reservation.guest_first_name': 'guest.first_name',
            'reservation.guest_last_name': 'guest.last_name',
            'reservation.guest_phone_numbers': 'guest.phone_numbers',
            'reservation.listing_security_price_accurate': 'reservation.security_price',
            'reservation.host_currency': 'resrevation.host_currency',
            'reservation.nights': 'reservation.nights_count',
            'reservation.status_type': 'reservation.status',
            'reservation.total_paid_amount_accurate': 'reservation.total_price'
          }
        )
      end

      let(:request1) do
        post '/v1/reservations', params: payload1, headers: { 'Content-Type' => 'application/json' }
      end

      let(:request2) do
        post '/v1/reservations', params: payload2, headers: { 'Content-Type' => 'application/json' }
      end
      let(:requests) do
        request1
        request2
      end

      before do
        invalid_payload_format
        valid_payload_format1
        valid_payload_format2
      end

      context 'when with valid params' do
        it 'returns 200' do
          requests
          expect(response).to have_http_status(200)
        end

        it 'creates a guest record' do
          expect { requests }.to change(Guest, :count).by(1)
        end

        it 'sets the payload data properly to guest' do
          requests

          expect(Guest.last).to have_attributes(guest_attrs)
        end

        it 'sets the payload data properly to reservation' do
          requests

          expect(Reservation.last).to have_attributes(reservation_attrs)
        end

        it 'creates a reservation record' do
          expect { requests }.to change(Reservation, :count).by(1)
        end
      end
    end

    context 'with no matched format' do
      let(:payload) do
        {
          reservation: {
            code: 'XXX12345678',
            start_date: '2021-03-12',
            end_date: '2021-03-16',
            expected_payout_amount: '3800.00',
            guest_details: {
              localized_description: '4 guests',
              number_of_adults: 2,
              number_of_children: 2,
              number_of_infants: 0
            },
            guest_email: 'wayne_woodbridge@bnb.com',
            guest_first_name: 'Wayne',
            guest_last_name: 'Woodbridge',
            guest_phone_numbers: %w[
              639123456789
              639123456789
            ],
            listing_security_price_accurate: '500.00',
            host_currency: 'AUD',
            nights: 4,
            number_of_guests: 4,
            status_type: 'accepted',
            total_paid_amount_accurate: '4300.00'
          }
        }.to_json
      end

      let(:guest_attrs) do
        {
          first_name: 'Wayne',
          last_name: 'Woodbridge',
          phone_numbers: %w[639123456789 639123456789],
          email: 'wayne_woodbridge@bnb.com'
        }
      end

      let(:reservation_attrs) do
        {
          code: 'XXX12345678',
          start_date: Date.parse('2021-03-12'),
          end_date: Date.parse('2021-03-16'),
          nights_count: 4,
          total_guests_count: 4,
          adults_count: 2,
          children_count: 2,
          infants_count: 0,
          status: 'accepted',
          host_currency: 'AUD',
          payout_price_cents: 380_000,
          security_price_cents: 50_000,
          total_price_cents: 430_000
        }
      end

      let(:invalid_payload_format) do
        create(
          :payload_format,
          provider: 'payload_1',
          schema: {
            'reservation.code': 'reservation.code',
            'reservation.start_date': 'reservation.start_date',
            'reservation.end_date': 'reservation.end_date',
            'reservation.expected_payout_amount': 'reservation.payout_price',
            'reservation.guest_details.adults_count': 'reservation.adults_count',
            'reservation.guest_details.children_count': 'reservation.children_count',
            'reservation.guest_details.infants_count': 'reservation.infant_count',
            'reservation.guest_email': 'guest.email',
            'reservation.guest_first_name': 'guest.first_name',
            'reservation.guest_last_name': 'guest.last_name',
            'reservation.guest_phone_numbers': 'guest.phone_numbers',
            'reservation.listing_security_price_accurate': 'reservation.security_price',
            'reservation.host_currency': 'resrevation.host_currency',
            'reservation.nights': 'reservation.nights_count',
            'reservation.status_type': 'reservation.status',
            'reservation.total_paid_amount_accurate': 'reservation.total_price'
          }
        )
      end

      let(:request) do
        post '/v1/reservations', params: payload, headers: { 'Content-Type' => 'application/json' }
      end

      before do
        invalid_payload_format
      end

      context 'when with no matching format' do
        it 'returns 422' do
          request

          expect(response).to have_http_status(422)
        end

        it 'returns the errors' do
          request

          expect(response.body).to include('errors')
        end

        it 'does not create a guest record' do
          expect { request }.not_to change(Guest, :count)
        end

        it 'does not create a reservation record' do
          expect { request }.not_to change(Reservation, :count)
        end
      end
    end
  end
end
