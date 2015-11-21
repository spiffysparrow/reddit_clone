class User < ActiveRecord::Base
  attr_reader :password

  validates :name, :password_digest, presence: true
  validates :session_token, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  after_initialize :ensure_session_token

  has_many :subs
  has_many :posts, dependent: :destroy

  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end

  def reset_session_token
    self.session_token = self.class.generate_session_token
    self.save
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(name, password)
    user = User.find_by(name: name)
    return nil if user.nil?
    user if user.is_password?(password)
  end

end
