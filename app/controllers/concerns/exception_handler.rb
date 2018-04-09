module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Neo4j::ActiveNode::Labels::RecordNotFound do |e|
      json_response({ message: I18n.t('errors.not_found') }, :not_found)
    end

    rescue_from Neo4j::ActiveNode::Persistence::RecordInvalidError do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end
  end
end
