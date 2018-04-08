module EmailValidationHelper
  def validate_emails(params)
    emails = params.first(2).compact
    # I18n, hardcoded text is bad
    if emails.length < 2 || emails.first.casecmp(emails.last).zero?
      json_response({ message: 'Two unique emails are required' }, :unprocessable_entity)
    end
    emails
  end
end
