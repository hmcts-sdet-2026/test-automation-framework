# Background steps
Given('a user exists with email {string} and password {string}') do |email, password|
  User.find_or_create_by!(email_address: email) do |user|
    user.password = password
  end
end

# Given steps
Given('I am on the login page') do
  @login_page = LoginPage.new
  @login_page.load
end

Given('I am logged in as {string} with password {string}') do |email, password|
  @login_page = LoginPage.new
  @login_page.load
  @login_page.login_with(email, password)
  @home_page = HomePage.new
end

# When steps
When('I log in with email {string} and password {string}') do |email, password|
  @login_page.login_with(email, password)
end

When('I fill in the email with {string}') do |email|
  @login_page.fill_in_email(email)
end

When('I fill in the password with {string}') do |password|
  @login_page.fill_in_password(password)
end

When('I click the sign in button') do
  @login_page.click_sign_in
end

When('I attempt to login {int} times with invalid credentials') do |count|
  count.times do
    @login_page.login_with('invalid@test.com', 'wrongpassword')
  end
end

When('I click the sign out link') do
  click_link 'Sign out'
end

# Then steps
Then('I should be on the home page') do
  @home_page = HomePage.new
  expect(page).to have_current_path('/')
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

Then('I should see {string} for the email field') do |error_message|
  error = @login_page.error_message_for(:email)
  expect(error).not_to be_nil, "Expected to find field-level error message but got nil"
  expect(error).to include(error_message)
end

Then('I should see {string} for the password field') do |error_message|
  error = @login_page.error_message_for(:password)
  expect(error).not_to be_nil, "Expected to find field-level error message but got nil"
  expect(error).to include(error_message)
end

Then('I should see an error summary') do
  expect(@login_page).to have_error_summary
end

Then('I should see an error message {string}') do |message|
  # This checks the error summary body (for authentication errors)
  within('.govuk-error-summary__body') do
    expect(page).to have_content(message)
  end
end

Then('I should remain on the login page') do
  expect(page).to have_button('Sign in')
  expect(page).to have_field('Email address')
end

Then('clicking the email error link should focus the email field') do
  # Click the error link for email field
  error_link = find('.govuk-error-summary__list a[href="#email_address"]')
  error_link.click

  # Allow time for focus to occur
  with_retry(max_attempts: 3, wait: 0.2) do
    focused_element_id = page.evaluate_script('document.activeElement.id')
    expect(focused_element_id).to eq('email_address').or eq('email-address-field')
  end
end

Then('clicking the password error link should focus the password field') do
  # Click the error link for password field
  error_link = find('.govuk-error-summary__list a[href="#password"]')
  error_link.click

  # Allow time for focus to occur
  with_retry(max_attempts: 3, wait: 0.2) do
    focused_element_id = page.evaluate_script('document.activeElement.id')
    expect(focused_element_id).to eq('password').or eq('password-field')
  end
end

Then('I should be redirected to the login page') do
  expect(page).to have_current_path(new_session_path)
end

Then('I should not be logged in') do
  expect(@login_page).not_to be_logged_in
end
