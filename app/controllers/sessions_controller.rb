class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
    @errors = {}
  end

  def create
    @errors = {}

    permitted = params.permit(:email_address, :password)

    # Validate required fields
    if error = validate_email(permitted[:email_address])
      @errors[:email_address] = error
    end

    if permitted[:password].blank?
      @errors[:password] = "Enter a password"
    end

    # If validation errors, re-render form
    if @errors.any?
      flash.now[:alert] = "There is a problem"
      render :new, status: :unprocessable_entity
      return
    end

    # Attempt authentication
    if user = User.authenticate_by(permitted)
      start_new_session_for user
      redirect_to after_authentication_url
    else
      # Generic error - don't reveal if email exists
      flash.now[:alert] = "Enter a valid email address and password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end
end
