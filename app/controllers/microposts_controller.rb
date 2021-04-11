class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  def index
    @microposts = Micropost.all
    @micropost =  Micropost.new
  end

  def new
    @micropost = Micropost.new
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.prefecture_id = params[:prefecture][:prefecture_id] if params[:prefecture].present?
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
    @micropost.prefecture_id = params[:prefecture][:prefecture_id] if params[:prefecture].present?
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

　#投稿検索フォーム用処理
  def search
    @q = Micropost.ransack(params[:q])
    @search_microposts = @q.result(distinct: true).page(params[:page]).per(10)
    if @search_microposts.present? & params[:prefecture].present?
      @prefecture_search_microposts = []
      @search_microposts.each do |micropost|
        @prefecture_search_microposts.push(micropost) if params[:prefecture][:prefecture_ids].include?(micropost.prefecture_id.to_s)
      end
      @search_microposts = @prefecture_search_microposts
    end
    if @search_microposts.present? & params[:genre].present?
      @genre_search_microposts = []
      @search_microposts.each do |micropost|
        params[:genre].each do |genre|
          @genre_search_microposts.push(micropost) if micropost.genre.include?(genre)
        end
      end
      @search_microposts = @genre_search_microposts
    end
    if @search_microposts.present? & params[:part].present?
      @part_search_microposts = []
      @search_microposts.each do |micropost|
        params[:part].each do |part|
          @part_search_microposts.push(micropost) if micropost.part.include?(part)
        end
      end
      @search_microposts = @part_search_microposts
    end
    @search_microposts = Kaminari.paginate_array(@search_microposts).page(params[:page]).per(10) if @search_microposts.present?
  end

　#ヘッダーのキーワード検索用処理
  def search_header
    @search = Micropost.ransack(params[:q])
    @search_microposts = @search.result(distinct: true).page(params[:page]).per(10)
    render "search"
  end

  #投稿一覧の表示件数変更処理
  def microposts_list_page
    @page = params[:per]
    @microposts = Micropost.paginate(page: params[:page], per_page: @page)
    render 'band_bulletin_boards/home'
  end

  def recruitment
  end

    private

  def micropost_params
    params.require(:micropost).permit(:title, :content_type, :content, :recruitment_min_age, :prefecture_id,
                                      :recruitment_max_age, :gender, :activity_day,
                                      :demo_sound_source, :activity_direction,
                                      { genre: [] }, { part: [] }, { music_type: [] }, { activity_day: [] }, { demo_sound_source: [] })
    end

  end
