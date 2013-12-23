class User < ActiveRecord::Base
  has_many :invites
  has_secure_password
  validates_format_of :login, with: /\A[a-z0-9_]{1,30}\z/
  validates_uniqueness_of :login

  before_validation :normalize_login

  def generate_invite
    Invite.create(user: self)
  end

  protected

  def normalize_login
    login.downcase!
  end
end
