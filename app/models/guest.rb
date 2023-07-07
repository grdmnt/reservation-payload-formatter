# frozen_string_literal: true

class Guest < ApplicationRecord
  validates :email, uniqueness: true

  def phone_numbers=(num)
    if num.is_a?(String)
      super([num])
    else
      super(num)
    end
  end
end
