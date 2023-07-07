# frozen_string_literal: true

MoneyRails.configure do |config|
  config.default_currency = :aud
  config.locale_backend = nil
  config.rounding_mode = BigDecimal::ROUND_HALF_EVEN
end
