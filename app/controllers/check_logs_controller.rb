class CheckLogsController < ApplicationController
  
  def index
    @check_logs = current_user.check_logs.order('created_at DESC').page(params[:page])
  end

  def create
    @check_log = current_user.check_logs.build(ring_params_1)
    if @check_log.save
#      flash[:success] = 'A check_log is recorded.'
      redirect_to check_front_url
    else
#      flash.now[:danger] = 'Can not be recorded a check_log.'
      render 'pages/ring_select_for_check'
    end

  end
end
