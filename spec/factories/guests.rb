# frozen_string_literal: true

FactoryBot.define do
  factory :guest do
    sequence :email do |n|
      "guest#{n}@example.com"
    end

    first_name { 'John' }
    last_name { 'Doe' }
    phone_numbers { ['0412345678'] }
  end
end
