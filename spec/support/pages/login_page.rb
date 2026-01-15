class LoginPage < BasePage
  def load
    visit "/session/new"
    self
  end

  def fill_in_email(email)
    fill_in "Email address", with: email
  end

  def fill_in_password(password)
    fill_in "Password", with: password
  end

  def click_sign_in
    click_button "Sign in"
  end

  def login_with(email, password)
    fill_in_email(email)
    fill_in_password(password)
    click_sign_in
  end

  def error_message_for(field)
    href = field == :password ? "#password" : "#email_address"
    find(".govuk-error-summary__list a[href='#{href}']", wait: 1).text
  rescue Capybara::ElementNotFound => e
    Rails.logger.debug("Error link not found for #{field}: #{e.message}")
    nil
  end

  def logged_in?
    has_link?("Sign out", wait: 1)
  end
end
