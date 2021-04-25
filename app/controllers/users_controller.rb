class UsersController < ApplicationController
  require "date"
  before_action :logged_in_user, only: [
    :edit, :update, :destroy,
  ]
  before_action :set_ransack
  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    birthday = @user.birthday.strftime("%Y%m%d")
    present_check(@user)
    @age = calcAge(birthday)
    @micropost = Micropost.new
    @microposts = @user.microposts.paginate(page: params[:page]).where('content LIKE ?', "%#{params[:search]}%")
    @part = @user.part
    @genre = @user.genre
    set_arrange
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.prefecture_id = params[:prefecture][:prefecture_id] if params[:prefecture].present?
    @user.user_image = "default.png"
    image_path = Rails.root.join("app", "assets", "images", "default.png")
    File.open(image_path) do |io|
      @user.user_image.attach(io: io, filename: "default.png")
      if @user.save
        @user.send_activation_email
        flash[:info] = "メールをチェックしてください"
        redirect_to root_url
      else
        render "users/new"
        flash[:danger] = "ユーザー登録に失敗しました"
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if params[:prefecture].present?
      @user.prefecture_id = params[:prefecture][:prefecture_id]
    end
    if params[:user][:user_image].present?
      @user.user_image = params[:user][:user_image]
      current_user.user_image = @user.user_image
    end
    if @user.update(user_params)
      if @user.part.present?
        @part = @user.part.gsub("[", "").chop!
      end
      birthday = @user.birthday.strftime("%Y%m%d")
      @age = calcAge(birthday)
      flash[:success] = "プロフィール更新しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def password_edit
  end

  def password_update
    user = User.find(params[:user_id])
    if user.authenticate(params[:user][:current_password])
      if params[:user][:password] == params[:user][:password_confirmation]
        if user.update(user_params)
          flash[:success] = 'パスワードを変更しました'
          redirect_to user
        else
          flash[:danger] = 'パスワードの変更に失敗しました'
          render 'password_edit'
        end
      else
        flash[:danger] = '新しいパスワードが一致しません'
        render 'password_edit'
      end
    else
      flash[:danger] = '現在のパスワードが違います'
      render 'password_edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "アカウントを削除しました"
    redirect_to root_path
  end

  # メンバー検索処理
  def search
    if params[:q][:birthday_gt].present?
      params[:q][:birthday_gt] = calc_min_birthday(params[:q][:birthday_gt])
    end
    if params[:q][:birthday_lt].present?
      params[:q][:birthday_lt] = calc_max_birthday(params[:q][:birthday_lt])
    end
    @q = User.ransack(params[:q])
    @search_users = @q.result(distinct: true).includes(:prefecture).all.page(params[:page]).
      includes({ user_image_attachment: :blob })
    if @search_users.present? & params[:prefecture].present?
      @prefecture_search_users = []
      @search_users.each do |user|
        if params[:prefecture][:prefecture_ids].include?(user.prefecture_id.to_s)
          @prefecture_search_users.push(user)
        end
      end
      @search_users = @prefecture_search_users
    end
    if @search_users.present? & params[:genre].present?
      @genre_search_users = []
      @search_users.each do |user|
        params[:genre].each do |genre|
          @genre_search_users.push(user) if user.genre.include?(genre)
        end
      end
      @search_users = @genre_search_users
    end
    if @search_users.present? & params[:part].present?
      @part_search_users = []
      @search_users.each do |user|
        params[:part].each do |part|
          @part_search_users.push(user) if user.part.include?(part)
        end
      end
      @search_users = @part_search_users
    end

    if @search_users.present?
      @search_users = @search_users.uniq
      @search_users.each do |user|
        present_check(user)
      end
    end
    if @search_users.present?
      @search_users = Kaminari.paginate_array(@search_users).page(params[:page]).per(10)
    end
  end

  def join
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation,
                                 :prefecture_id, :gender, :artist, :url, :agreement,
                                 :birthday, :uid, :provider, { genre: [] }, { part: [] })
  end

  # 不要な記号を削除し整理
  def present_check(user)
    if user.part.present?
      user.part = user.part.delete('] [ 0 ""')
    end
    if user.genre.present?
      user.genre = user.genre.delete('] [ ""')
    end
    user
  end

  # ransack検索用
  def set_ransack
    @q = User.ransack(params[:q])
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
