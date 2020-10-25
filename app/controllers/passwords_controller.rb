class PasswordsController < ApplicationController

  def edit
  end

  def update
    if current_user.update_with_password(user_params)
      redirect_to account_path
    else
      render :edit
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
