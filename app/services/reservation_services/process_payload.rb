# frozen_string_literal: true

module ReservationServices
  class ProcessPayload < BaseService
    attr_accessor :payload

    def initialize(payload:)
      self.payload = payload.is_a?(String) ? JSON.parse(payload) : payload
    end

    def call
      flattened_payload = flatten_payload(payload)

      matched_format = PayloadFormat.all.find do |format|
        match_format?(format, flattened_payload)
      end

      fail!(message: 'No matched format found') if matched_format.nil?

      guest, reservation = process_matched_format(matched_format, flattened_payload)

      errors = save_records(guest, reservation)

      fail!(errors:) if errors.any?

      build_result(flattened_payload:, guest:, reservation:)
    end

    private

    def match_format?(format, flattened_payload)
      (format.schema.keys - flattened_payload.keys).empty?
    end

    def flatten_payload(hash, parent_key = nil)
      flat_hash = {}

      hash.each do |key, value|
        current_key = parent_key.present? ? "#{parent_key}.#{key}" : key.to_s

        if value.is_a?(Hash)
          flat_hash = flat_hash.merge(flatten_payload(value, current_key))
        else
          flat_hash[current_key] = value
        end
      end

      flat_hash
    end

    def process_matched_format(matched_format, flattened_payload)
      guest, reservation = fetch_records(matched_format, flattened_payload)

      matched_format.schema.each do |key, value|
        next if value == 'reservation.code'

        model, attribute = value.split('.')
        case model
        when 'guest'
          guest.send("#{attribute}=", flattened_payload[key])
        when 'reservation'
          reservation.send("#{attribute}=", flattened_payload[key])
        end
      end

      reservation.payload_format = matched_format

      [guest, reservation]
    end

    def fetch_records(matched_format, flattened_payload)
      guest_email = flattened_payload[matched_format.schema.key('guest.email')]
      reservation_code = flattened_payload[matched_format.schema.key('reservation.code')]

      reservation = Reservation.find_or_initialize_by(code: reservation_code)
      guest = reservation.guest.present? ? reservation.guest : reservation.build_guest(email: guest_email)

      [guest, reservation]
    end

    def save_records(guest, reservation)
      guest.save && reservation.save

      guest.errors.full_messages + reservation.errors.full_messages
    end
  end
end
