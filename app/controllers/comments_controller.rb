class CommentsController < ApplicationController
  def create
    micropost = Micropost.find(params[:micropost_id])
    @comment = micropost.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = "コメントしました!"
      @micropost = @comment.micropost
      @micropost.create_notification_comment!(current_user, @comment.id)
      redirect_to @comment.micropost
    else
      binding.pry
      flash[:danger] = "コメントに失敗しました"
      redirect_to controller: :microposts, action: :show, id: micropost.id
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    flash[:success] = "コメントを削除しました!"
    redirect_to micropost_path(params[:micropost_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
