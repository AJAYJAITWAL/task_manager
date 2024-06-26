class User < ApplicationRecord
  has_many :tickets, dependent: :destroy

  enum role: { user: 0, admin: 1 }, _default: :user

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
