class HomePage < BasePage
  def has_welcome_message_for?(email)
    has_text?("You are signed in as #{email}")
  end
end
