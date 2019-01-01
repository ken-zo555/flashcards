class PagesController < ApplicationController

# @check_status {select,continue,question_view,answer_view,result_view,end}
# @check_style {ox_front_back,ox_back_front,input_front_back,input_back_front}


  def index
    if user_signed_in?
      @user = current_user
      @card = last_card
      @ring = last_ring
      @check = last_check
      counts(@user)
    end
  end

  def show
    if user_signed_in?
      @user = current_user
    end
  end
  
  def ring_select_for_check
    if user_signed_in?
      @user = current_user
      @card = last_card
      @ring = last_ring
      @check_status = current_user.check_logs.last
      if @check_status == 'continue' # 継続中
        redirect_to(controller: 'pages', action: 'check_front', method: :get, id: @current_check_ring_id, card_num: @current_check_card_num)
      else
        counts(@user)
        @rings = current_user.rings.order('id DESC').page(params[:page])
        @ring = current_user.rings.build  # form_for 用
        @check_status = 'select'
      end
    end
  end
  
  def check_front
    if user_signed_in?
      @user = current_user
      @card ||= last_card
      counts(@user)
      @check_status = params[:check_status] 
      if @check_status == 'continue' # 継続中
      
      elsif @check_status == 'answer_view' # 答え表示
        @ring = Ring.find(params[:ring_id])
        @check_log =  CheckLog.find(params[:check_log_id])
        @card_content = CheckCard.find_by(check_log_id: @check_log.id, num_of_log: @check_log.solved_question).content_2
        @check_log.solved_question += 1
        if @check_log.save
          render 'pages/check_front'
        else
          flash.now[:danger] = 'Can not be updated the check_log.'
          redirect_to root_url
        end

      elsif @check_status == 'question_view' # 2問目以降の問題表示
        @ring = Ring.find(params[:ring_id])
        @check_log =  CheckLog.find(params[:check_log_id])
        @result_of_question = params[:result_of_question]
        if @result_of_question == 'true'
          @check_log.correct_question += 1
        else
          @check_log.false_question += 1
        end
        @card_content = CheckCard.find_by(check_log_id: @check_log.id, num_of_log: @check_log.solved_question).content_1
        if @check_log.save
          render 'pages/check_front'
        else
          flash.now[:danger] = 'Can not be updated the check_log.'
          redirect_to root_url
        end

      elsif @check_status == 'result_view' # 結果表示
        @ring = Ring.find(params[:ring_id])
        @check_log =  CheckLog.find(params[:check_log_id])
        @result_of_question = params[:result_of_question]
        if @result_of_question == 'true'
          @check_log.correct_question += 1
        else
          @check_log.false_question += 1
        end
        if @check_log.save
          render 'pages/check_front'
        else
          flash.now[:danger] = 'Can not be updated the check_log.'
          redirect_to root_url
        end

      elsif @check_status == 'end' # 終了
        
      elsif @check_status == 'select' #初期化
        @ring = Ring.find(params[:ring_id])
        @cards = current_user.cards.joins(:rings).where(rings:{id: @ring.id}).page(params[:page])
        @check_log = current_user.check_logs.build
        @check_log.user = current_user
        @check_log.ring_id = @ring.id
        @check_log_last = current_user.check_logs.where(user_id: current_user).order('id DESC').find_by(user_id: current_user)
#        logger.debug(@check_log_last.to_yaml)
        @check_log.period = @check_log_last.present? ? @check_log_last.period.to_i + 1 : 1
        @check_log_last_of_ring = current_user.check_logs.where(ring_id: @ring.id).order('id DESC').find_by(ring_id: @ring.id)
        @check_log.period_of_ring = @check_log_last_of_ring.present? ? @check_log_last_of_ring.period_of_ring.to_i + 1 : 1
        @check_log.total_question = @cards.count
        @check_log.status = params[:check_status]
        if @check_log.save
#          flash.now[:success] = 'The check_log is updated.'
          @cards.shuffle.each_with_index do |card, i|
            @check_card = @check_log.check_cards.build
            @check_card.update_attributes(content_1: card.content_1, content_2: card.content_2, num_of_log: i)
            @check_card.save
          end
          @check_log.solved_question = 0
          @check_log.correct_question = 0
          @check_log.false_question = 0
          @check_log.save
          @card_content = CheckCard.find_by(check_log_id: @check_log.id, num_of_log: 0).content_1
          @check_status = 'question_view'
          render 'pages/check_front'
        else
          flash.now[:danger] = 'Can not be updated the check_log.'
          redirect_to root_url
        end
      else
          flash.now[:danger] = 'Something trouble is occerd about check_status.'
          redirect_to root_url
      end
    end
  end
  
  private
  
  def set_ring
    @ring = Ring.find(params[:ring_id])
  end
  
  def set_check_card_num
    @check_card_num = params[:card_num].to_i
  end
end
