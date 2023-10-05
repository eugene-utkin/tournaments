class TournamentsController < ApplicationController
  before_action :set_new_tournament, only: [:new, :create]

  def index

  end

  def new; end

  private

  def set_new_tournament
    @tournament = Tournament.new
  end
end
