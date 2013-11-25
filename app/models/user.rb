class User < ActiveRecord::Base
  has_secure_password
  validates_format_of :login, with: /\A[a-z0-9_]{1,30}\z/i
  validates_uniqueness_of :login

  before_validation :normalize_login

  protected

  def normalize_login
    login.downcase!
  end
end
