class Match < ApplicationRecord
  belongs_to :tournament
  belongs_to :team_a, class_name: 'Team'
  belongs_to :team_b, class_name: 'Team'

  enum stage: %i[
    division_a
    division_b
    playoff
  ].index_with(&:to_s)

  enum result: %i[
    not_played_yet
    team_a_won
    team_b_won
    draw
  ].index_with(&:to_s)
end
