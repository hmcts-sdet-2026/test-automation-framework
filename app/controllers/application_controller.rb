class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Use GOV.UK Design System form builder by default
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  private

  # Shared validation for email address fields
  # Returns error message if invalid, nil if valid
  def validate_email(email)
    return "Enter an email address" if email.blank?
    return "Enter an email address in the correct format, like name@example.com" unless email.match?(URI::MailTo::EMAIL_REGEXP)
    nil
  end
end
