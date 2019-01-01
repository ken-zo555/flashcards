class CardRingLinksController < ApplicationController
  before_action :require_user_signed_in

  def create
    @user = current_user
    @card = Card.find(params[:card_id])
    @ring = Ring.find(params[:ring_id])
    @card.add_to_ring(@ring)

    if @card.save && @ring.save
      flash[:success] = 'A card is added to a ring.'
#      counts(@user)
      redirect_back(fallback_location: root_path)
    else
      @rings = current_user.rings.order('id DESC').page(params[:page])
      flash.now[:danger] = 'Can not be added to a ring.'
      redirect_back(fallback_location: root_path)
    end

  end

  def destroy
    @user = current_user
    @ring = Ring.find(params[:ring_id])
    @card = Card.find(params[:card_id])
    @card.remove_from_ring(@ring)

    if @card.save && @ring.save
      flash[:success] = 'The card is removed from a ring'
#      counts(@user)
      redirect_back(fallback_location: root_path)
    else
      @rings = current_user.rings.order('id DESC').page(params[:page])
      flash.now[:danger] = 'Can not be removed from a ring.'
      redirect_back(fallback_location: root_path)
    end

  end

  def card_params_id
    params.require(:card).permit(:card_id)
  end

  def ring_params_id
    params.require(:ring).permit(:ring_id)
  end

end
