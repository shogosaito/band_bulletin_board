class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, omniauth_providers: [:facebook, :twitter, :google_oauth2]
  include DeviseTokenAuth::Concerns::User
  devise :omniauthable, omniauth_providers: [:facebook, :twitter, :google_oauth2]
  serialize :tokens
  has_one_attached :user_image
  belongs_to :prefecture
  has_many :microposts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :micropost
  has_many :comments, dependent: :destroy
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :user_name, presence: true, length: { maximum: 15 }
  validates :gender, presence: true
  validates :email, presence: true, length: { maximum: 255 }
  validates :birthday, presence: true
  validates :part, presence: true
  validates :selfintroduction, length: { maximum: 120 }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  validates_acceptance_of :agreement, allow_nil: false, on: :create

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

  def already_liked?(micropost)
    likes.exists?(micropost_id: micropost.id)
  end

  def self.from_omniauth(auth)
    sns = SnsCredential.where(uid: auth["uid"], provider: auth["provider"]).first_or_create
    user = sns.user || User.where(email: auth["info"]["email"]).first
    if user.blank?
      user = User.new(
        uid: auth["uid"],
        provider: auth["provider"],
        user_name: auth["info"]["name"],
        email: auth["info"]["email"],
        oauth_token: auth.credentials.token,
        oauth_expires_at: Time.at(auth.credentials.expires_at),
        password: rondom_password,
        gender: auth["info"]["gender"],
        birthday: auth["info"]["birthday"],
        user_image: 'default.png'
      )
    end
    if user.user_name.blank?
      user.user_name = rondom_name
    end
    if user.password.blank?
      user.password = rondom_password
    end
    if user.persisted? # userが登録済みの場合：そのままログインするため、snsのuser_idを更新しとく
      sns.user = user
      sns.save
    end
    { user: user, sns: sns }
    end

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    self.email = email.downcase
  end

  # user_name作成
  def self.rondom_name
    "#{((0..9).to_a + ("a".."z").to_a).sample(10).join}"
  end

  # password作成
  def self.rondom_password
    "#{((0..9).to_a + ("a".."z").to_a).sample(10).join}"
  end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
