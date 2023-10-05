class TournamentsController < ApplicationController
  before_action :set_tournament, :set_tournament_teams, only: [:show, :edit, :update, :destroy, :create_matches]
  before_action :set_new_tournament, only: [:new, :create]

  def index
    @tournaments = Tournament.all
  end

  def show; end

  def new; end

  def create
    @tournament.assign_attributes(tournament_params)

    if @tournament.save
      redirect_to tournament_url(@tournament), notice: 'Success!'
    else
      flash.now[:alert] = @tournament.errors.full_messages
      render 'new'
    end
  end

  def edit; end

  def update
    if @tournament.update(tournament_params)
      redirect_to tournament_url(@tournament), notice: 'Success!'
    else
      flash.now[:alert] = @tournament.errors.full_messages
      render 'edit'
    end
  end

  def destroy
    @tournament.destroy
    redirect_to tournaments_url, notice: 'Success!'
  end

  def create_random_teams
    tournament = Tournament.new(name: "Random Tournament")
    16.times do |i|
      tournament.teams << Team.new(name: (i + 1).to_s)
    end
    if tournament.save
      redirect_to tournament_url(tournament), notice: 'Success!'
    else
      flash.now[:alert] = tournament.errors.full_messages
      render 'new'
    end
  end

  def create_matches
    if @tournament.matches.empty?
      @tournament.create_division_matches
    else
      @tournament.create_playoff_matches
    end

    if @tournament.save
      redirect_to tournament_url(@tournament), notice: 'Success!'
    else
      flash.now[:alert] = @tournament.errors.full_messages
      render 'new'
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, {
      teams_attributes: [:id, :name]
    })
  end

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def set_new_tournament
    @tournament = Tournament.new
  end

  def set_tournament_teams
    @tournament_teams = @tournament.teams
    if @tournament_teams.empty?
      16.times do
        @tournament_teams << Team.new
      end
    end
    @tournament_teams_with_names = @tournament_teams.where.not(name: "")
  end
end
