require "faker"

class Team < ApplicationRecord
  belongs_to :tournament
  has_many :matches_as_team_a, :class_name => 'Match', :foreign_key => 'team_a_id', dependent: :destroy
  has_many :matches_as_team_b, :class_name => 'Match', :foreign_key => 'team_b_id', dependent: :destroy

  def generate_random_name
    update!(name: Faker::Sports::Football.team)
  end
end
