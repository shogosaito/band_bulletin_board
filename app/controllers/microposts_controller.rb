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
    if @micropost.save!
      flash[:success] = "投稿しました!"
      redirect_to root_url
    else
      @feed_items = [current_user.feed.paginate(page: params[:page])]
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
    if @part.end_with?(",")
      @part = @part.chop
    end
    if @genre.start_with?(",")
      @genre.slice!(0)
    end
    if @genre.end_with?(",")
      @genre = @genre.chop
    end

    # @activity_day.reject(&:empty?)
    # for @micropost.music_type.each do |music_type|
    #   unless music_type == "0"
    #     @music_type = music_type
    #   end
    # end
  end

  def edit
    @micropost = Micropost.find(params[:id])
  end

  def update
    @micropost = Micropost.find_by(id: params[:id])
    if @micropost.update(micropost_params)
      flash[:notice] = "投稿を編集しました"
      redirect_to("/microposts/index")
    else
      render("/microposts/edit")
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿を削除しました。"
    redirect_to root_url
  end

  def search
    @q = Micropost.ransack(params[:q])
    @search_microposts = @q.result(distinct: true)
    if @search
      @search_microposts = @search.result(distinct: true)
    end
  end

  def recruitment
  end


  private

  def micropost_params
    params.require(:micropost).permit(:title, :content_type, :content, :part, :prefecture_id, :music_type,
                                       :recruitment_min_age, :recruitment_max_age, :gender, :activity_day,
                                       :demo_sound_source, :activity_direction, { genre: [] }, { part: [] }, { music_type: [] }, { activity_day: [] })
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
