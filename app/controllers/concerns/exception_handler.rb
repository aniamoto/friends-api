module ExceptionHandler
  extend ActiveSupport::Concern

  # Use I18n for messages, hardcoded text is bad!
  HTTP_MESSAGE_NOT_FOUND = 'Object not found'

  included do
    rescue_from Neo4j::ActiveNode::Labels::RecordNotFound do |e|
      json_response({ message: HTTP_MESSAGE_NOT_FOUND }, :not_found)
    end

    rescue_from Neo4j::ActiveNode::Persistence::RecordInvalidError do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end
  end
end
