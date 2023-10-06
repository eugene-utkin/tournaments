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

  def create_playoff_matches
    playoff_matches = matches.where(stage: 'playoff')
    if playoff_matches.empty?
      best_teams = (best_division_a_teams + best_division_b_teams).sort_by { -_1[1] }.map { _1[0] }
      (best_teams.length / 2).times do |i|
        matches << Match.new(team_a: best_teams[i], team_b: best_teams[-i - 1], stage: "playoff", playoff_number: 1)
      end
    else
      max_round = max_playoff_round
      max_round_playoff_matches = matches.where(playoff_number: max_round).order(:created_at)
      starting_index = 0
      while max_round_playoff_matches[starting_index]
        first_match = max_round_playoff_matches[starting_index]
        second_match = max_round_playoff_matches[starting_index + 1]

        first_match_winner = first_match.match_winner
        second_match_winner = second_match.match_winner

        matches << Match.new(team_a: first_match_winner, team_b: second_match_winner, stage: "playoff", playoff_number: max_round + 1)
        starting_index += 2
      end
    end
    save!
  end

  def best_division_a_teams
    best_teams(matches.where(stage: 'division_a'))
  end

  def best_division_b_teams
    best_teams(matches.where(stage: 'division_b'))
  end

  def max_playoff_round
    matches.sort_by { -_1.playoff_number }.first.playoff_number 
  end

  private

  def best_teams(matches)
    results = {}
    matches.each do |match|
      results[match.match_winner] ||= 0
      results[match.match_looser] ||= 0
      results[match.match_winner] += 1
    end
    results.sort_by { -_2 }.first(4)
  end
end
