class Tournament < ApplicationRecord
  enum stage: %i[
    registration
    divisions
    playoffs
    completed
  ].index_with(&:to_s)
end
