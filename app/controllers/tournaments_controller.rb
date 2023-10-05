class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy]
  before_action :set_new_tournament, only: [:new, :create]

  def index

  end

  def show

  end

  def new; end

  def create
    @tournament.assign_attributes(tournament_params)

    if @tournament.save
      redirect_to tournament_url(@tournament), notice: t(".success")
    else
      flash.now[:alert] = @tournament.errors.full_messages
      render 'new'
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name)
  end

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def set_new_tournament
    @tournament = Tournament.new
  end
end
