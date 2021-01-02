class UsersController < ApplicationController
    require "date"
    before_action :logged_in_user, only: [
      :index, :edit, :update, :destroy,
      :following, :followers,
    ]
    before_action :correct_user, only: [:edit, :update]

    def index
      @user = User.paginate(page: params[:page])
      @q = User.ransack(params[:q])
      @search_users = @q.result(distinct: true)
      if @search
        @search_users = @search.result(distinct: true)
      end
    end

    def show
      @user = User.find(params[:id])
      birthday = @user.birthday.strftime("%Y%m%d").to_i
      unless @user.part.blank?
        @part = @user.part.delete('] [ 0 ""')
      end
      unless @user.genre.blank?
        @genre = @user.genre.delete('] [ ""')
      end
      @age = calcAge(birthday)
      @micropost = Micropost.new
      @microposts = @user.microposts.paginate(page: params[:page]).where('content LIKE ?', "%#{params[:search]}%")
      if @micropost
        @feed_items = []
      end
    end

    def new
      @user = User.new
    end

    def create
      if ENV['omniauth.auth'].present?
        # snsログイン
        @user = User.from_omniauth(env['omniauth.auth'])
        result = @user.save(context: :sns_login)
      else
        # 通常サインアップ
        # 　　 params[:user][:birthday] = birthday_join
        @user = User.new(user_params)
        @user.prefecture_id = params[:prefecture][:prefecture_ids]
        @user.user_image = 'default.png'
        image_path = Rails.root.join("app", "assets", "images", "default.png")
        File.open(image_path) do |io|
          @user.user_image.attach(io: io, filename: "default.png")
          if @user.save
            @user.send_activation_email
            flash[:info] = "メールをチェックして初期設定を行ってください"
            redirect_to root_url
          else
            flash[:danger] = "ユーザー登録に失敗しました。"
            render "users/new"
          end
        end
        if result
          sign_in @user
          flash[:success] = "#{@user.provider}ログインしました。"
          redirect_to @user
        else
        end
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      @user.prefecture_id = params[:prefecture][:prefecture_ids]
      @user.user_image = params[:user_image]
      current_user.user_image = @user.user_image
    if @user.update(user_params)
      unless @user.part.blank?
        @part = @user.part.gsub("[","").chop!
      end
      birthday = @user.birthday.strftime("%Y%m%d").to_i
      @age = calcAge(birthday)
        flash[:success]="プロフィール更新しました"
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

    def destroy
      User.find(params[:id]).destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    end

    def sns_login
      @user = User.from_omniauth(request.env["omniauth.auth"])
      result = @user.save(context: :sns_login)
      if result
        log_in @user
        redirect_to @user
      else
        redirect_to auth_failure_path
      end
    end

    # 認証に失敗した際の処理
    def auth_failure
      @user = User.new
      render 'root_path'
    end

    def search
      unless params[:search_min_age] == ""
        # 指定された年齢となる生年月日をyyyymmdd形式の文字列へと変換
        younger_birth_ymd = calc_min_birthday(params[:search_min_age]).to_s
      else
        # 最小の年齢として0歳にした
        younger_birth_ymd = calc_min_birthday("0").to_s
      end
      unless params[:search_max_age] == ""
        older_birth_ymd = calc_max_birthday(params[:search_max_age]).to_s
      else
        # 最大の年齢として十分な150歳にした
        older_birth_ymd = calc_min_birthday("150").to_s
      end
      # yyyymmdd形式の生年月日を日付形式に変換
      younger_birthday = Time.parse(younger_birth_ymd)
      older_birthday = Time.parse(older_birth_ymd)
      # 条件に当てはまるUserを検索
      @users = User.where(birthday: older_birthday..younger_birthday)
      @q = User.ransack(params[:q])
      @search_users = @q.result(distinct: true)
      # @search = User.ransack(params[:q])
      # @search_users = @search.result.page(params[:page])
    end

    def join
    end

    private

    def user_params
      params.require(:user).permit(:user_name, :email, :password, :password_confirmation,
         :prefecture_id,:checkbox_example, :gender, :genre, :artist, :url, :prefecture,
         :selfintroduction, :agreement, :birthday, :pid, :provider,:user_image, { part: [] })
      end

      def birthday_join
        date = @user.birthday
        Date.new date["birthday(1i)"].to_i, date["birthday(2i)"].to_i, date["birthday(3i)"].to_i
      end

      # 正しいユーザーかどうか確認
      def correct_user
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user)
      end
    end
