class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :invitee, class_name: 'User'

  validates_presence_of :user
  validates_uniqueness_of :code

  after_initialize :generate_code

  def activate!(invitee)
    if self.invitee.nil?
      self.invitee = invitee
      self.save!
    else
      raise I18n.t('activerecord.errors.invite.already_activated')
    end
  end

private
  def generate_code
    if self.code.nil?
      self.code = ''
      Time.now.to_i.to_s(36).reverse.each_char do |char|
        self.code += char + rand(36).to_s(36)
      end

      self.code = self.code.scan(/.{4}/)[0..2].join('-')
    end
  end
end
