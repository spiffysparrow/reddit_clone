class Post < ActiveRecord::Base
  validates :title, :sub_id, :user_id, presence: true
  belongs_to :user
  belongs_to :sub
  
end
