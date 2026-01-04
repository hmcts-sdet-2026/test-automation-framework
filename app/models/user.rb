class User < ApplicationRecord
  # Adds password & password_confirmation attributes, validates & encrypts password to password_digest
  has_secure_password
  # User can have multiple sessions (devices), all sessions deleted when user is deleted
  has_many :sessions, dependent: :destroy

  # Automatically strips whitespace and converts email to lowercase before saving
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
