require 'rails_helper'
require 'axe-rspec'

RSpec.describe "Accessibility", type: :feature, js: true do
  let(:user) { User.find_or_create_by!(email_address: "test@test.com") { |u| u.password = "password123" } }

  describe "Login page" do
    it "meets WCAG 2.1 AA standards" do
      visit new_session_path

      expect(page).to be_axe_clean
        .according_to(:wcag21aa)
        .excluding('.govuk-skip-link') # Skip link may have known axe issues with display:none
    end

    it "has no critical accessibility violations" do
      visit new_session_path

      # Run full accessibility audit
      expect(page).to be_axe_clean.according_to(:wcag21aa)
    end
  end

  describe "Homepage (authenticated)" do
    before do
      # Log in first
      visit new_session_path
      fill_in "Email address", with: user.email_address
      fill_in "Password", with: "password123"
      click_button "Sign in"
    end

    it "meets WCAG 2.1 AA standards" do
      expect(page).to be_axe_clean
        .according_to(:wcag21aa)
        .excluding('.govuk-skip-link')
    end
  end

  describe "GOV.UK Design System components" do
    it "error summary component is accessible" do
      visit new_session_path

      # Trigger validation errors
      click_button "Sign in"

      expect(page).to be_axe_clean
        .within('.govuk-error-summary')
        .according_to(:wcag21aa)
    end

    it "form validation with errors is accessible" do
      visit new_session_path

      # Trigger validation errors
      click_button "Sign in"

      # Test the entire page with errors displayed
      expect(page).to be_axe_clean.according_to(:wcag21aa)
    end
  end
end
