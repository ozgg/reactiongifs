class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :invitee, class_name: 'User'
end
