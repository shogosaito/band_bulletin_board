class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:destroy]


  def index
    @microposts = Micropost.all  #投稿一覧を表示させるために全取得
    @micropost =  Micropost.new   #投稿一覧画面で新規投稿を行うので、formのパラメータ用にPostオブジェクトを取得
  end

  def new
    @micropost = Micropost.new
  end

  def create
    # @micropost = current_user.microposts.build(micropost_params)
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "投稿しました!"
      redirect_to root_url
    else
      @feed_items = [current_user.feed.paginate(page: params[:page])]
      render 'static_pages/home'
    end
  end

  def show
    @micropost = Micropost.find(params[:id])
    @like = Like.new
    @comments = @micropost.comments
    @comment = Comment.new

  end

  def update
    @micropost = Post.find_by(id: params[:id])
    @micropost.content = params[:content]
    if @micropost.save
      flash[:notice] = "投稿を編集しました"
      redirect_to("/microposts/index")
    else
      render("/microposts/edit")
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image ,:user_id,:micropost_id)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
