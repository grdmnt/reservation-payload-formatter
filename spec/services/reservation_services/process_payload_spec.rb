# frozen_string_literal: true

require 'rails_helper'

describe ReservationServices::ProcessPayload do
  describe '.call' do
    subject(:call_service) { described_class.call(**params) }

    let(:valid_payload_format) do
      create(
        :payload_format,
        schema: {
          'a' => 'guest.email',
          'b.c' => 'guest.first_name',
          'b.d.e' => 'reservation.code',
          'b.f' => 'reservation.total_price'
        }
      )
    end

    let(:invalid_payload_format) do
      create(
        :payload_format,
        schema: {
          'a' => 'guest.email',
          'b.c' => 'guest.first_name',
          'b.d.e' => 'reservation.code',
          'b.f' => 'guest.last_name',
          'g' => 'reservation.total_price'
        }
      )
    end

    let(:params) do
      {
        payload: {
          'a' => 'john@doe.com',
          'b' => {
            'c' => 'John',
            'd' => {
              'e' => '123ABC'
            },
            'f' => '500.00'
          }
        }.to_json
      }
    end

    before do
      invalid_payload_format
      valid_payload_format
    end

    context 'when with valid params' do
      it 'succeeds' do
        expect(call_service).to be_a_success
      end

      it 'creates a guest record' do
        expect { call_service }.to change(Guest, :count).by(1)
      end

      it 'sets the payload data properly to guest' do
        call_service

        expect(Guest.last).to have_attributes(email: 'john@doe.com', first_name: 'John')
      end

      it 'sets the payload data properly to reservation' do
        call_service

        expect(Reservation.last).to have_attributes(
          code: '123ABC', total_price_cents: 50_000, guest_id: Guest.last.id, payload_format: valid_payload_format
        )
      end

      it 'creates a reservation record' do
        expect { call_service }.to change(Reservation, :count).by(1)
      end
    end

    context 'when with invalid params' do
      let(:params) do
        {
          payload: {
            'a' => 'john@doe.com',
            'b' => {
              'c' => 'John',
              'f' => '500.00'
            }
          }.to_json
        }
      end

      it 'fails' do
        expect(call_service).to be_a_failure
      end

      it 'does not create a guest record' do
        expect { call_service }.not_to change(Guest, :count)
      end

      it 'does not create a reservation record' do
        expect { call_service }.not_to change(Reservation, :count)
      end
    end

    context 'when reservation already exists with the same code' do
      before do
        guest = create(:guest, email: 'john@doe.com', first_name: 'Not John')

        create(:reservation, code: '123ABC', total_price_cents: 25_000, guest:)
      end

      it 'succeeds' do
        expect(call_service).to be_a_success
      end

      it 'does not creates a guest record' do
        expect { call_service }.not_to change(Guest, :count)
      end

      it 'sets the payload data properly to guest' do
        call_service

        expect(Guest.last).to have_attributes(email: 'john@doe.com', first_name: 'John')
      end

      it 'sets the payload data properly to reservation' do
        call_service

        expect(Reservation.last).to have_attributes(
          code: '123ABC', total_price_cents: 50_000, guest_id: Guest.last.id, payload_format: valid_payload_format
        )
      end

      it 'does not create a reservation record' do
        expect { call_service }.not_to change(Reservation, :count)
      end
    end
  end
end
