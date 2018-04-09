module EmailValidationHelper
  def validate_emails(params)
    emails = params.first(2).compact

    if emails.length < 2 || emails.first.casecmp(emails.last).zero?
      json_response(
        { message: I18n.t('errors.friendships.unique_emails') },
        :unprocessable_entity
      )
    end
    emails
  end
end
