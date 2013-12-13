class AddModerationToUser < ActiveRecord::Migration
  def change
    add_column :users, :can_post, :boolean, default: true
    add_column :users, :trusted, :boolean, default: false
    add_column :users, :moderator, :boolean, default: false

    User.all.each do |user|
      user.can_post  = true
      user.trusted   = true
      user.moderator = true
      user.save
    end
  end
end
