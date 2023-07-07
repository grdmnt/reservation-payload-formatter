# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe '#valid?' do
    subject(:reservation) { build(:reservation) }

    context 'when with valid params' do
      it 'is valid' do
        expect(reservation).to be_valid
      end
    end

    context 'when with existing code' do
      before do
        create(:reservation, code: reservation.code)
      end

      it 'is invalid' do
        expect(reservation).not_to be_valid
      end
    end
  end
end
