# frozen_string_literal: true

module V1
  class ReservationsController < ApplicationController
    def upsert
      result = ReservationServices::ProcessPayload.call(payload: request.raw_post)

      if result.success?
        render json: { guest: result.guest, reservation: result.reservation }, status: :ok
      else
        render json: { errors: result.errors }, status: :unprocessable_entity
      end
    end
  end
end
