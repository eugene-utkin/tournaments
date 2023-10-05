class Tournament < ApplicationRecord
  has_many :teams, dependent: :destroy

  accepts_nested_attributes_for :teams,
                                allow_destroy: true

  enum stage: %i[
    registration
    divisions
    playoffs
    completed
  ].index_with(&:to_s)
end
