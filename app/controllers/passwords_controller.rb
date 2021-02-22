class PasswordsController < UsersController
  def edit
    # @user = User.find(current_user.id)
  end

  def update
    if update_with_password(user_params)
      redirect_to current_user
    else
      render :edit
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end

  def users_update
    public_method(:update).super_method.call
  end

  def update_with_password(params)
    @new_password = params[:password]
    @password_confirmation = params[:password_confirmation]
    @current_password = params[:current_password]
    binding.pry
    if current_user.password == @current_password
      if @new_password == @password_confirmation
        Devise::LDAP::Adapter.update_own_password(login_with, @new_password, @current_password)
      else
        flash[:danger] = '新しいパスワードが一致しません'
      end
    else
      flash[:danger] = '現在のパスワードが違います'
    end
 end
end
