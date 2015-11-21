class Post < ActiveRecord::Base
  validates :title, :sub_id, :user_id, presence: true
  belongs_to :user
  belongs_to :sub
  has_many :postsubs
  has_many :subs, through: :postsubs, source: :sub

end
