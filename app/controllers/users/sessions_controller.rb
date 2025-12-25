class Users::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: [:guest_sign_in]

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to foods_path, success: 'ゲストユーザーとしてログインしました。'
  end
end
