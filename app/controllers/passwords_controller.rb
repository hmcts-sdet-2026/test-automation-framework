class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_password_path, alert: "Try again later." }

  def new
    @errors = {}
  end

  def create
    @errors = {}

    # Validate email field
    if error = validate_email(params[:email_address])
      @errors[:email_address] = error
      flash.now[:alert] = "There is a problem"
      render :new, status: :unprocessable_entity
      return
    end

    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end

  def edit
    @errors = {}
  end

  def update
    @errors = {}

    # Validate password fields
    if params[:password].blank?
      @errors[:password] = "Enter a new password"
    elsif params[:password].length < 3
      @errors[:password] = "Password must be at least 3 characters"
    end

    if params[:password_confirmation].blank?
      @errors[:password_confirmation] = "Confirm your new password"
    elsif params[:password].present? && params[:password] != params[:password_confirmation]
      @errors[:password_confirmation] = "Passwords do not match"
    end

    if @errors.any?
      flash.now[:alert] = "There is a problem"
      render :edit, status: :unprocessable_entity
      return
    end

    if @user.update(params.permit(:password, :password_confirmation))
      @user.sessions.destroy_all
      redirect_to new_session_path, notice: "Password has been reset."
    else
      flash.now[:alert] = "There was a problem resetting your password."
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
    end
end
