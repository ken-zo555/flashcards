class RingsController < ApplicationController
  attr_accessor :id
  before_action :require_user_signed_in
  before_action :set_ring, only: [:show, :edit, :update, :destroy]

  def index
    if user_signed_in?
      @ring = current_user.rings.build  # form_for 用
      @search_word = "(All)"
      @search_count = current_user.rings.search(params[:search]).count
      @rings = current_user.rings.order('id DESC').page(params[:page])
      counts(current_user)
    end
  end

  def show
    if user_signed_in?
      @user = current_user
      @rings = current_user.rings.order('id DESC').page(params[:page])
      @cards = current_user.cards.joins(:rings).where(rings:{id: @ring.id}).page(params[:page])
    end
  end

  def new
    if user_signed_in?
      @user = current_user
      @ring = current_user.rings.new
    end
  end

  def create
    @ring = current_user.rings.build(ring_params_1)
    if @ring.save
      flash[:success] = 'A ring is recorded.'
      redirect_to rings_url
    else
      @rings = current_user.rings.order('id DESC').page(params[:page])
      flash.now[:danger] = 'Can not be recorded a ring.'
      render 'rings/index'
    end
  end

  def edit
    @user = current_user
    @cards = current_user.cards.order('id DESC').page(params[:page])
  end

  def update
    if user_signed_in?
      @user = current_user
      if @ring.update(ring_params_1)
        flash[:success] = 'The ring is updated.'
        redirect_to rings_url
      else
        flash.now[:danger] = 'Can not be updated the ring.'
        render 'rings/index'
      end
    end
  end

  def destroy
    @ring.destroy
    flash[:success] = 'The ring is discarded'
    redirect_back(fallback_location: root_path)
  end
  
  def search
    if user_signed_in?
      @ring = current_user.rings.build  # form_for 用
      if params[:search] == ( nil || '' )
        @search_word = "(All)"
      else
        @search_word = params[:search]
      end
      @search_count = current_user.rings.search(params[:search]).count
      @rings = current_user.rings.search(params[:search]).order('id DESC').page(params[:page])
      counts(current_user)
      render 'rings/index'
    end
  end
  
  private
  def set_ring
    @ring = Ring.find(params[:id])
  end
  
  def ring_params_1
    params.require(:ring).permit(:ring_name)
  end
  
end
