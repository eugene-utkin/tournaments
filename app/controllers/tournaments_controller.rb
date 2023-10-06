class TournamentsController < ApplicationController
  before_action :set_tournament, :set_tournament_teams, except: [:new, :create, :index]
  before_action :set_variables, only: [:show, :edit, :create_random_division_a_results, :create_random_division_b_results, :create_random_playoff_results]
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
    @tournament_teams.each_with_index do |team, team_i|
      team.update!(name: (team_i + 1).to_s)
    end
    redirect_to tournament_url(@tournament), notice: 'Success!'
  end

  def create_matches
    if @tournament.matches.empty?
      @tournament.create_division_matches
    else
      @tournament.create_playoff_matches
    end

    redirect_to tournament_url(@tournament), notice: 'Success!'
  end

  def create_random_division_a_results
    create_random_match_results(@division_a_matches)
  end

  def create_random_division_b_results
    create_random_match_results(@division_b_matches)
  end

  def create_random_playoff_results
    create_random_match_results(@max_round_playoff_matches)
  end

  def finish
    @tournament.stage = 'completed'
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
    }, {
      matches_attributes: [:id, :result]
    })
  end

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def set_tournament_teams
    @tournament_teams = @tournament.teams
    if @tournament_teams.empty?
      16.times do
        @tournament_teams << Team.new
      end
      @tournament.save!
    end
  end

  def set_variables
    @tournament_teams_with_names = @tournament_teams.where.not(name: "")
    @matches = @tournament.matches
    @division_matches = @matches.where.not(stage: 'playoff') if !@matches.empty?
    @divison_matches_with_results = @division_matches.where.not(result: 'not_played_yet') if @division_matches
    @division_a_matches = @division_matches.where(stage: 'division_a').order(:created_at) if @division_matches
    @division_b_matches = @division_matches.where(stage: 'division_b').order(:created_at) if @division_matches
    @division_a_matches_with_results = @division_a_matches.where.not(result: 'not_played_yet') if @division_a_matches
    @division_b_matches_with_results = @division_b_matches.where.not(result: 'not_played_yet') if @division_b_matches
    @playoff_matches = @matches.where(stage: 'playoff') if !@matches.empty?
    @max_playoff_round = @tournament.max_playoff_round if !@playoff_matches.empty?
    @max_round_playoff_matches = @playoff_matches.where(playoff_number: @max_playoff_round).order(:created_at) if !@playoff_matches.empty?
    @max_round_playoff_matches_with_results = @max_round_playoff_matches.where.not(result: 'not_played_yet') if @max_round_playoff_matches
  end

  def set_new_tournament
    @tournament = Tournament.new
  end

  def create_random_match_results(matches)
    matches.each do |match|
      if rand >= 0.5
        match.update!(result: 'team_a_won')
      else
        match.update!(result: 'team_b_won')
      end
    end
    redirect_to tournament_url(@tournament), notice: 'Success!'
  end
end
