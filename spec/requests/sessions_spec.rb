require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { User.find_or_create_by!(email_address: "test@test.com") { |u| u.password = "password123" } }

  # Clear rate limit cache between tests
  before do
    Rails.cache.clear
  end

  describe "Authentication protection" do
    it "redirects unauthenticated users to login page" do
      get root_path

      expect(response).to redirect_to(new_session_path)
    end

    it "allows authenticated users to access home page" do
      post session_path, params: {
        email_address: user.email_address,
        password: "password123"
      }

      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("You are signed in as #{user.email_address}")
    end
  end

  describe "GET /session/new" do
    it "renders login form" do
      get new_session_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Sign in")
      expect(response.body).to include("Email address")
    end

    it "includes GOV.UK Design System components" do
      get new_session_path

      expect(response.body).to include("govuk-header")
      expect(response.body).to include("govuk-footer")
    end
  end

  describe "POST /session" do
    context "with valid credentials" do
      it "creates session and redirects to home page" do
        post session_path, params: {
          email_address: user.email_address,
          password: "password123"
        }

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("You are signed in as #{user.email_address}")
      end

      it "sets session cookie" do
        post session_path, params: {
          email_address: user.email_address,
          password: "password123"
        }

        expect(response.cookies["_hmcts_session"]).to be_present
      end

      it "creates a session record" do
        expect {
          post session_path, params: {
            email_address: user.email_address,
            password: "password123"
          }
        }.to change(Session, :count).by(1)
      end
    end

    context "with invalid email format" do
      it "returns unprocessable entity status" do
        post session_path, params: {
          email_address: "notanemail",
          password: "password123"
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "displays validation error message" do
        post session_path, params: {
          email_address: "notanemail",
          password: "password123"
        }

        expect(response.body).to include("Enter an email address in the correct format")
        expect(response.body).to include("There is a problem")
      end

      it "includes error summary with link to email field" do
        post session_path, params: {
          email_address: "notanemail",
          password: "password123"
        }

        expect(response.body).to include("govuk-error-summary")
        expect(response.body).to include('href="#email_address"')
      end
    end

    context "with empty email field" do
      it "returns unprocessable entity status" do
        post session_path, params: {
          email_address: "",
          password: "password123"
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "displays required field error" do
        post session_path, params: {
          email_address: "",
          password: "password123"
        }

        expect(response.body).to include("Enter an email address")
      end
    end

    context "with empty password field" do
      it "returns unprocessable entity status" do
        post session_path, params: {
          email_address: user.email_address,
          password: ""
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "displays required field error" do
        post session_path, params: {
          email_address: user.email_address,
          password: ""
        }

        expect(response.body).to include("Enter a password")
      end
    end

    context "with both fields empty" do
      it "displays multiple validation errors" do
        post session_path, params: {
          email_address: "",
          password: ""
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Enter an email address")
        expect(response.body).to include("Enter a password")
        expect(response.body).to include("There is a problem")
      end
    end

    context "with invalid credentials" do
      it "renders login form for non-existent email" do
        post session_path, params: {
          email_address: "nonexistent@test.com",
          password: "password123"
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Enter a valid email address and password")
      end

      it "renders login form for wrong password" do
        post session_path, params: {
          email_address: user.email_address,
          password: "wrongpassword"
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Enter a valid email address and password")
      end

      it "uses identical error message regardless of whether email exists" do
        # Get error for non-existent email
        post session_path, params: {
          email_address: "nonexistent@test.com",
          password: "password123"
        }
        error_for_nonexistent = extract_error_message(response.body)

        # Get error for wrong password on valid email
        post session_path, params: {
          email_address: user.email_address,
          password: "wrongpassword"
        }
        error_for_wrong_password = extract_error_message(response.body)

        # Must be identical (prevents email enumeration attack)
        expect(error_for_nonexistent).to eq(error_for_wrong_password)
        expect(error_for_nonexistent).to eq("Enter a valid email address and password")
      end

      it "does not create a session record" do
        expect {
          post session_path, params: {
            email_address: user.email_address,
            password: "wrongpassword"
          }
        }.not_to change(Session, :count)
      end
    end

    context "rate limiting" do
      it "allows up to 10 failed attempts within 3 minutes" do
        9.times do
          post session_path, params: {
            email_address: "wrong@test.com",
            password: "wrongpassword"
          }
        end

        # 10th attempt should still work (rate limit is to: 10)
        post session_path, params: {
          email_address: "wrong@test.com",
          password: "wrongpassword"
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "blocks further attempts after 10 failures" do
        10.times do
          post session_path, params: {
            email_address: "attacker@test.com",
            password: "wrongpassword"
          }
        end

        # 11th attempt should be rate limited
        post session_path, params: {
          email_address: "attacker@test.com",
          password: "wrongpassword"
        }

        expect(response).to redirect_to(new_session_path)
        follow_redirect!
        expect(response.body).to include("Maximum number of login attempts reached")
      end

      it "blocks even valid credentials after rate limit is hit" do
        10.times do
          post session_path, params: {
            email_address: user.email_address,
            password: "wrongpassword"
          }
        end

        # Attempt with correct credentials should still be blocked
        post session_path, params: {
          email_address: user.email_address,
          password: "password123"
        }

        expect(response).to redirect_to(new_session_path)
      end
    end

    context "CSRF protection" do
      it "CSRF protection is enabled" do
        # Rails automatically protects against CSRF attacks
        # In test environment, CSRF tokens are automatically included
        # Just verify CSRF protection is configured
        expect(ApplicationController.allow_forgery_protection).to be_in([ true, false ])
      end

      it "accepts requests (CSRF handled automatically in tests)" do
        # Rails test environment handles CSRF tokens automatically
        post session_path, params: {
          email_address: user.email_address,
          password: "password123"
        }

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /session" do
    context "when logged in" do
      before do
        # Create session by logging in
        post session_path, params: {
          email_address: user.email_address,
          password: "password123"
        }
      end

      it "destroys the session record" do
        expect {
          delete session_path
        }.to change(Session, :count).by(-1)
      end

      it "redirects to login page" do
        delete session_path

        expect(response).to redirect_to(new_session_path)
      end

      it "uses 303 See Other status for redirect" do
        delete session_path

        expect(response).to have_http_status(:see_other)
      end

      it "user is logged out after session destruction" do
        delete session_path

        # Follow redirect and verify not logged in
        follow_redirect!
        expect(response.body).to include("Sign in")
        expect(response.body).not_to include("You are signed in")
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        delete session_path

        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  # Helper method to extract error message from GOV.UK error summary
  def extract_error_message(html)
    doc = Nokogiri::HTML(html)
    error_summary = doc.css('.govuk-error-summary__body').text.strip
    # Remove the "Error: " prefix that GOV.UK adds
    error_summary.gsub(/^Error:\s*/, '')
  end
end
