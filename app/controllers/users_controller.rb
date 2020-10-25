class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
    :following, :followers]
    before_action :correct_user,   only: [:edit, :update]


    def index
      @user = User.paginate(page: params[:page])
      @users = User.all
    end

    def show
      @user = User.find(params[:id])
      @micropost = Micropost.new
      @microposts = @user.microposts.paginate(page: params[:page]).where('content LIKE ?', "%#{params[:search]}%")
      if  @micropost
        @feed_items = []
      end
    end

    def new
      @user = User.new
    end

    def create
      if  ENV['omniauth.auth'].present?
        # Facebookログイン
        @user = User.from_omniauth(env['omniauth.auth'])
        result = @user.save(context: :facebook_login)
        fb       = "Facebook"
        redirect_to root_url
      else
        # 通常サインアップ
        @user = User.new(user_params)
        @user.user_image = nil
        fb       = ""
        if @user.save!
          flash[:info] = "新規登録しました"
          log_in @user
          redirect_to root_url
        end
        if result
          sign_in @user
          flash[:success] = "#{fb}ログインしました。"
          redirect_to @user
        else
          if fb.present?
            redirect_to auth_failure_path
          end
        end
      end
      if @user.selfintroduction.blank?
        @user.selfintroduction = "よろしくお願いします。"
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      @user.user_image = params[:user_image]
      current_user.user_image = @user.user_image
      if @user.update(user_params)
        flash[:success] = "プロフィール更新しました"
        redirect_to @user
      else
        render 'edit'
      end
    end

    def destroy
      User.find(params[:id]).destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    end

    def following
      @title = "フォロー"
      @user  = User.find(params[:id])
      @users = @user.following.paginate(page: params[:page])
      render 'show_follow'
    end

    def followers
      @title = "フォロワー"
      @user  = User.find(params[:id])
      @users = @user.followers.paginate(page: params[:page])
      render 'show_follow'
    end

    def facebook_login
      @user = User.from_omniauth(request.env["omniauth.auth"])
      result = @user.save(context: :facebook_login)
      if result
        log_in @user
        redirect_to @user
      else
        redirect_to auth_failure_path
      end
    end

    #認証に失敗した際の処理
    def auth_failure
      @user = User.new
      render 'root_path'
    end

    private

    def user_params
      params.require(:user).permit(:full_name, :user_name, :email, :password,
        :password_confirmation, :weburl,:selfintroduction,:phonenumber,:gender,:user_image)
      end


      # 正しいユーザーかどうか確認
      def correct_user
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user)
      end
    end
