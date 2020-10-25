class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter, :google_oauth2]
  include DeviseTokenAuth::Concerns::User
  devise :omniauthable
  serialize :tokens
  has_one_attached :user_image
  has_many :microposts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :micropost
  has_many :comments,dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
  foreign_key: "follower_id",
  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name:  "Relationship",
  foreign_key: "followed_id",
  dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token
  validates :full_name,  presence: true, length: { maximum: 50 }
  validates :user_name, uniqueness: true, presence: true,length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 }, allow_nil: true
  validates :selfintroduction,length: { maximum: 120 }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true



  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  # ユーザーのステータスフィードを返す
  def feed
    following_ids = "SELECT followed_id FROM relationships
    WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
    OR user_id = :user_id", user_id: id)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  def already_liked?(micropost)
    self.likes.exists?(micropost_id: micropost.id)
  end

  def self.from_omniauth(auth)
    user = User.where('email = ?', auth.info.email).first
    where(provider: auth.provider, uid: auth.uid).first_or_create do |users|
    if user.blank?
      user = User.new
    end
    user.uid   = auth.uid
    user.provider = auth.provider,
    user.user_name  = auth.info.name
    user.email = auth.info.email
    user.oauth_token = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user.password = Devise.friendly_token[0, 20]
  end
  return user
end
# def self.find_for_oauth(auth)
#   user = User.where(uid: auth.uid, provider: auth.provider).first
#
#   unless user
#     user = User.create(
#       uid:      auth.uid,
#       provider: auth.provider,
#       email:    User.dummy_email(auth),
#       password: Devise.friendly_token[0, 20]
#     )
#   end
#   user
# end

private

    def self.dummy_email(auth)
      "#{auth.uid}-#{auth.provider}@example.com"
    end

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
