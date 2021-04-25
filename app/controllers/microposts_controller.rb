class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:destroy]
  def index
    @microposts = Micropost.all
    @micropost =  Micropost.new
  end

  def new
    @micropost = Micropost.new
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if params[:prefecture].present?
      @micropost.prefecture_id = params[:prefecture][:prefecture_id]
    end
    if @micropost.save
      flash[:success] = "投稿しました!"
      redirect_to root_url
    else
      flash[:danger] = "投稿に失敗しました!"
      render 'microposts/new'
    end
  end

  def show
    @micropost = Micropost.find(params[:id])
    $post_user = @micropost.user
    @like = Like.new
    @comments = @micropost.comments
    @comment = Comment.new
    @activity_day = @micropost.activity_day.to_s.delete('] , [ 0 ""')
    @music_type = @micropost.music_type.to_s.delete('],[ 0 ""')
    @part = @micropost.part.to_s.delete(']  [ 0 ""')
    @genre = @micropost.genre.delete(']  [ 0 ""')
    if @part.start_with?(",")
      @part.slice!(0)
    end
    if @genre.start_with?(",")
      @genre.slice!(0)
    end
    set_arrange
  end

  def edit
    @micropost = Micropost.find(params[:id])
  end

  def update
    @micropost = Micropost.find_by(id: params[:id])
    if params[:prefecture].present?
      @micropost.prefecture_id = params[:prefecture][:prefecture_id]
    end
    if @micropost.update!(micropost_params)
      flash[:success] = "投稿を編集しました"
      redirect_to @micropost
    else
      render '/microposts/edit'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿を削除しました。"
    redirect_to root_url
  end

  # 投稿検索フォーム用処理
  def search
    @q = Micropost.ransack(params[:q])
    @search_microposts = @q.result(distinct: true).includes(:user, user: :prefecture).all.
      page(params[:page]).includes(user: { user_image_attachment: :blob })
    if @search_microposts.present? & params[:prefecture].present?
      @prefecture_search_microposts = []
      @search_microposts.each do |micropost|
        if params[:prefecture][:prefecture_ids].include?(micropost.prefecture_id.to_s)
          @prefecture_search_microposts.push(micropost)
        end
      end
      @search_microposts = @prefecture_search_microposts
    end
    if @search_microposts.present? & params[:genre].present?
      @genre_search_microposts = []
      @search_microposts.each do |micropost|
        params[:genre].each do |genre|
          if micropost.genre.include?(genre)
            @genre_search_microposts.push(micropost)
          end
        end
      end
      @search_microposts = @genre_search_microposts
    end
    if @search_microposts.present? & params[:part].present?
      @part_search_microposts = []
      @search_microposts.each do |micropost|
        params[:part].each do |part|
          if micropost.part.include?(part)
            @part_search_microposts.push(micropost)
          end
        end
      end
      @search_microposts = @part_search_microposts
    end
    if @search_microposts.present?
      @search_microposts = Kaminari.paginate_array(@search_microposts).page(params[:page]).per(10)
    end
  end

  # ヘッダーのキーワード検索用処理
  def search_header
    @search = Micropost.ransack(params[:q])
    @search_microposts = @search.result(distinct: true).includes(:user, user: :prefecture).all.
      page(params[:page]).includes(user: { user_image_attachment: :blob }).per(10)
    render "search"
  end

  # 投稿一覧の表示件数変更処理
  def microposts_list_page
    @page = params[:per]
    @microposts = Micropost.paginate(page: params[:page], per_page: @page)
    render 'band_bulletin_boards/home'
  end

  # ユーザに紐づいた記事を取得
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end

  def recruitment
  end

  private

  def micropost_params
    params.require(:micropost).permit(:title, :content_type, :content, :recruitment_min_age, :prefecture_id,
                                      :recruitment_max_age, :gender, :activity_day,
                                      :demo_sound_source, :activity_direction,
                                      { genre: [] }, { part: [] }, { music_type: [] },
                                      { activity_day: [] }, { demo_sound_source: [] })
  end
end
