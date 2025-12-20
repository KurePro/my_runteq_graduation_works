class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.order(created_at: :desc)
    @notifications.where(checked: false).update_all(checked: true)
  end

  def destroy
    notification = current_user.notifications.find(params[:id])
    notification.destroy
    redirect_to notifications_path, status: :see_other
  end
end
