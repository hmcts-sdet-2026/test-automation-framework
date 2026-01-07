class User < ApplicationRecord
  # Adds password & password_confirmation attributes, validates & encrypts password to password_digest
  has_secure_password
  # User can have multiple sessions (devices), all sessions deleted when user is deleted
  has_many :sessions, dependent: :destroy

  # Automatically strips whitespace and converts email to lowercase before saving
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Model-level validations for data integrity
  validates :email_address, presence: true,
    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" },
    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 3 }, if: -> { password.present? }
end
