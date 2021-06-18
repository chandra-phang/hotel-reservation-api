module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class Unauthorized < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized
    rescue_from ExceptionHandler::MissingToken, with: :unprocessable_entity
    rescue_from ExceptionHandler::InvalidToken, with: :unprocessable_entity
    rescue_from ExceptionHandler::Unauthorized, with: :unauthorized
    rescue_from RailsParam::Param::InvalidParameterError, with: :unprocessable_entity
  end

  private

  def not_found(e)
    json_response({ message: e.message }, :not_found)
  end

  def unprocessable_entity(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end

  def unauthorized(e)
    json_response({ message: e.message }, :unauthorized)
  end
end
