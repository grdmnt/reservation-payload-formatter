# frozen_string_literal: true

# BaseService serves as the base foundations of services implementations.
# All common code, structure, and helpers can be placed here.
class BaseService
  attr_accessor :failed, :errors

  def self.call(*args, **kwargs)
    instance = new(*args, **kwargs)
    instance.initialize_defaults
    instance.call
  rescue FailedServiceError => e
    e.payload
  end

  def fail!(errors: [], message: nil, **fields)
    self.failed = true

    errors = errors.to_a << message if message.present?

    payload = build_result(service: self.class.name, errors:, message:, **fields)

    raise FailedServiceError, payload
  end

  def success?
    !failed
  end

  def failure?
    failed
  end

  def build_result(errors: [], message: nil, **fields)
    self.errors += errors.to_a

    OpenStruct.new(
      success?: success?,
      failure?: failure?,
      errors: self.errors,
      message: message || self.errors.to_sentence,
      **fields
    )
  end

  def initialize_defaults
    self.failed = false
    self.errors = []
  end
end
