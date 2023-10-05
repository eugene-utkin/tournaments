class Team < ApplicationRecord
  belongs_to :tournament

  enum stage: %i[
    registration
    divisions
    playoffs
    completed
  ].index_with(&:to_s)

  enum divison: %i[
    division_a
    division_b
  ].index_with(&:to_s)
end
