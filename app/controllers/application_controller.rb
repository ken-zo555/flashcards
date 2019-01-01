class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    case resource
      when User
        root_path
    end
  end
 
  def last_card  # 最新のもの
    if user_signed_in?
       @last_card ||= current_user.cards.last
    end
  end

  def last_ring  # 最新のもの
    if user_signed_in?
       @last_ring ||= current_user.rings.last
    end
  end
  
  def last_check # 最新のもの
    if user_signed_in?
      @last_check ||= current_user.check_logs.last
    end
  end
  
  protected
 
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
  
  private
  
  def require_user_signed_in
    unless user_signed_in?
      redirect_to  new_user_session_path
    end
  end
  
  def counts(user)
    @count_cards = user.cards.count
    @count_rings = user.rings.count

# TODO: リングに紐づいているカード数のカウント ⇒　Viewで実装
#    user.rings.each { |f|
#     @count_cards_of_rings = Card.joins(:rings).select(where(user: user, rings: f).count
#    @count_card_of_ring.store(f.id, f.ring_name)
#    }
    @count_cards_of_rings = user.cards.joins(:rings).group(:ring_id).count
  end
  
  def checklist(user,ring)
    @check_list_of_cards = user.cards.joins(:rings).group(ring).page(params[:page])
  end

end
