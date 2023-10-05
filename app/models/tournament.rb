class Tournament < ApplicationRecord
  has_many :teams, dependent: :destroy
  has_many :matches, dependent: :destroy

  accepts_nested_attributes_for :teams
  accepts_nested_attributes_for :matches

  enum stage: %i[
    registration
    divisions
    playoffs
    completed
  ].index_with(&:to_s)

  def create_division_matches
    shuffled_teams = teams.shuffle

    division_a_teams = shuffled_teams[..shuffled_teams.length / 2 - 1]
    division_b_teams = shuffled_teams[shuffled_teams.length / 2..]

    division_a_teams.each_with_index do |team_a, team_a_index|
      team_b_index = team_a_index + 1
      while division_a_teams[team_b_index]
        matches << Match.new(team_a:, team_b: division_a_teams[team_b_index], stage: "division_a")
        team_b_index += 1
      end
    end

    division_b_teams.each_with_index do |team_a, team_a_index|
      team_b_index = team_a_index + 1
      while division_b_teams[team_b_index]
        matches << Match.new(team_a:, team_b: division_b_teams[team_b_index], stage: "division_b")
        team_b_index += 1
      end
    end

    save!
  end
end
