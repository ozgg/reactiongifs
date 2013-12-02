class Reaction < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :title
  validates :image, presence: true, on: :create
  before_validation :trim_title

  mount_uploader :image, ReactionUploader

protected
  def trim_title
    title.strip!
  end
end
