class Admin < ApplicationRecord
  has_secure_password
  before_save {self.email = email.downcase}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 105}, uniqueness: {case_sensitivity: false}, format: {with: VALID_EMAIL_REGEX}
end
