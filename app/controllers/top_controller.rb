class TopController < ApplicationController
  skip_before_action :authenticate_user!

  layout "top"
end
