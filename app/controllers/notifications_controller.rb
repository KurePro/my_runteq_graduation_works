class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page]).per(5)
    current_user.notifications.where(checked: false).update_all(checked: true)
  end

  def destroy_all
    current_user.notifications.destroy_all
    redirect_to notifications_path, notice: "通知を削除しました。", status: :see_other
  end
end
