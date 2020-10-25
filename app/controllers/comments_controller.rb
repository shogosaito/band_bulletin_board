class CommentsController < ApplicationController
  def create
    micropost = Micropost.find(params[:micropost_id])
    @comment = micropost.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = "コメントしました!"
      @micropost=@comment.micropost
      @micropost.create_notification_comment!(current_user, @comment.id)
      redirect_to @comment.micropost
    else
      flash[:success] = "コメントに失敗しました"
      render template: 'microposts/show'
    end
  end


  def new
    @comment = Comment.new
  end



  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    redirect_to @comment
  end

  def destroy
    @comment.destroy
    flash[:success] = "コメントを削除しました!"
    redirect_to microposts_path
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
