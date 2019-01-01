class CardsController < ApplicationController
  attr_accessor :id
  before_action :require_user_signed_in
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  def index
    if user_signed_in?
      @user = current_user
      @card = current_user.cards.build  # form_for 用
      @cards = current_user.cards.order('created_at DESC').page(params[:page])
    end
  end

  def show
  end

  def edit
    @rings = current_user.rings.order('id DESC').page(params[:page])
    @ring = current_user.rings.build  # form_for 用
    @user = current_user
    counts(@user)
  end
  
  def update
    if user_signed_in?
      @user = current_user
      if @card.update(card_params_1_2)
        flash[:success] = 'Front & back side of the card is updated.'
        redirect_to cards_url
      else
        flash.now[:danger] = 'Can not be updated front & back side of the card.'
        render 'cards/index'
      end
    end
  end

  def new
    if user_signed_in?
      @user = current_user
      @card = current_user.cards.new
    end
  end

  def create
    @card = current_user.cards.build(card_params_1_2)
    if @card.save
      flash[:success] = 'A card is recorded.'
      redirect_to cards_url
    else
      @cards = current_user.cards.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'Can not be recorded a card.'
      render 'cards/index'
    end
  end

  def destroy
    @card.destroy
    flash[:success] = 'The card is discarded'
    redirect_back(fallback_location: root_path)
  end
  
  def front 
  end
  
  def front_save
    if user_signed_in?
      @user = current_user
      @card = current_user.cards.build(card_params_1)
      if @card.save
        @@current_card = @card
        flash[:success] = 'Front side of the card is recorded.'
        redirect_to cards_back_url
      else
        flash.now[:danger] = 'Can not be recorded front side of a card.'
        render 'cards/index'
      end
    end
  end

  def back
    @card = @@current_card
  end

  def back_save
    if user_signed_in?
      @user = current_user
      @card = @@current_card
      @card.attributes = { content_1: card_params_1["content_1"] }
      @card.attributes = { content_2: card_params_2["content_2"] }
      if @card.save
        flash[:success] = 'Front & back side of the card is recorded.'
        redirect_to edit_card_path(@card)
      else
        flash.now[:danger] = 'Can not be recorded front & back side of a card.'
        render 'cards/index'
      end
    end
  end
  
  
  
private
  def set_card
    @card = Card.find(params[:id])
  end
  
  def card_params_1
    params.require(:card).permit(:content_1)
  end

  def card_params_2
    params.require(:card).permit(:content_2)
  end

  def card_params_1_2
    params.require(:card).permit(:content_1,:content_2)
  end

  def ring_params_id
    params.require(:ring).permit(:ring_id)
  end
end
