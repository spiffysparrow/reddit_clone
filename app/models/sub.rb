class Sub < ActiveRecord::Base
  validates :title, :user_id, presence: true

  belongs_to :moderator,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: "User"

  has_many :posts, dependent: :destroy


end
