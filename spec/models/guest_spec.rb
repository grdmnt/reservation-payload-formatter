# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe '#valid?' do
    subject(:guest) { build(:guest) }

    context 'when with valid params' do
      it 'is valid' do
        expect(guest).to be_valid
      end
    end

    context 'when with existing email' do
      before do
        create(:guest, email: guest.email)
      end

      it 'is invalid' do
        expect(guest).not_to be_valid
      end
    end
  end
end
